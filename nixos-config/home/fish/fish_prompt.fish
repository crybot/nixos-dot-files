# Function body

set -l last_status $status
set -l normal (set_color normal)
set -l status_color (set_color brgreen)
set -l cwd_color (set_color --bold $fish_color_cwd)
set -l vcs_color (set_color --bold brpurple)
set -l prompt_status ""

# Since we display the prompt on a new line allow the directory names to be longer.
set -q fish_prompt_pwd_dir_length
or set -lx fish_prompt_pwd_dir_length 0

# Color the prompt differently when we're root
 set -l suffix '❯'
if functions -q fish_is_root_user; and fish_is_root_user
  if set -q fish_color_cwd_root
    set cwd_color (set_color $fish_color_cwd_root)
  end
  set suffix '#'
end

# Color the prompt in red on error
if test $last_status -ne 0
  set status_color (set_color $fish_color_error)
  set prompt_status $status_color "[" $last_status "]" $normal
end

# # Add virtualenv display
set -l venv_prompt ''
if set -q VIRTUAL_ENV; and not functions -q deactivate
  # Extract the name (basename) of the virtual environment directory
  set -l venv_name (basename "$VIRTUAL_ENV")
  # Output the name, maybe with formatting (e.g., parentheses, color)
  # This example uses blue color
  # echo -n -s (set_color blue) "(" $venv_name ")" (set_color normal) " "
  set venv_prompt (set_color blue) "(" $venv_name ")" (set_color normal) " "
end   

# SSH connection indicator
set -l ssh_indicator ''
if set -q SSH_CONNECTION
  # SSH_CONNECTION format: client_ip client_port server_ip server_port
  set -l ssh_parts (string split ' ' $SSH_CONNECTION)
  set -l server_ip $ssh_parts[3] # The server IP is the 3rd element
  set ssh_indicator (set_color bryellow)"on 🌐$server_ip "(set_color normal)
end

# Show virtualenv/mode prompt (relies on fish_mode_prompt checking VIRTUAL_ENV)
set -l mode_prompt ''
if functions -q fish_mode_prompt # Check if the function exists
  set mode_prompt (fish_mode_prompt)
end

echo -s $mode_prompt $venv_prompt (prompt_login) ' ' $ssh_indicator $cwd_color (prompt_pwd) $normal $vcs_color (fish_vcs_prompt) \
        $normal ' ' $prompt_status
echo -n -s $status_color $suffix ' ' $normal
