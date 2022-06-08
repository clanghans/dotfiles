;;; org/roam-extra/config.el -*- lexical-binding: t; -*-
;;; https://magnus.therning.org/2021-03-14-keeping-todo-items-in-org-roam.html

(defun roam-extra:todo-p ()
  "Return non-nil if current buffer has any TODO entry.

TODO entries marked as done are ignored, meaning the this
function returns nil if current buffer contains only completed
tasks."
  (org-element-map
      (org-element-parse-buffer 'headline)
      'headline
    (lambda (h)
      (eq (org-element-property :todo-type h)
          'todo))
    nil 'first-match))

(defun roam-extra:update-todo-tag ()
  "Update TODO tag in the current buffer."
  (when (and (not (active-minibuffer-window))
             (org-roam-file-p))
    (if (roam-extra:todo-p)
        (org-roam-tag-add (list "todo"))
      (org-roam-tag-remove (list "todo"))
      )
    )
  )

(defun roam-extra:todo-files ()
  "Return a list of note files containing todo tag."
  (seq-map
   #'car
   (org-roam-db-query
    [:select file
     :from nodes
     :inner :join tags
     :on (= nodes:id tags:node_id)
     :where (like tag (quote "%\"todo\"%"))
     ]
    )
   )
  )

(defun roam-extra:update-todo-files (&rest _)
  "Update the value of `org-agenda-files'."
  (setq org-agenda-files (roam-extra:todo-files))
  )

(after! org
  (add-hook 'org-roam-file-setup-hook #'roam-extra:update-todo-tag)
  (add-hook 'before-save-hook #'roam-extra:update-todo-tag)
  (advice-add 'org-agenda :before #'roam-extra:update-todo-files)
  )
