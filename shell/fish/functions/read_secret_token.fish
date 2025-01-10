function read_secret_token
    # Prompt the user to enter a secret token interactively
    read -s -P "Enter your secret token: " user_input
    set -x API_KEY $user_input
    echo "Secret token stored in this session under API_KEY."
end
