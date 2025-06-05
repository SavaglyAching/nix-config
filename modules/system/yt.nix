{ pkgs, config, ... }: # Your existing home.nix arguments

{


  # 2. Configure Bash (or Zsh, see note below)
  programs.zsh.initExtra = ''
    # Function to run yt-dlp with ntfy start/finish notifications
    _yt_with_ntfy() {
        # --- USER CONFIGURATION START ---
        local ntfy_topic="your_ntfy_topic"  # !!! IMPORTANT: Change this to your ntfy.sh topic !!!
        local ntfy_server="https://ntfy.sh"    # Change if you self-host ntfy
        # If your ntfy topic requires authentication, add curl options like:
        # local ntfy_auth_header="-H \"Authorization: Bearer your_access_token\""
        # local ntfy_auth_header="-u \"user:pass\""
        local ntfy_auth_header="" # No auth by default
        # --- USER CONFIGURATION END ---

        local args_string="$*" # Capture all arguments for use in notification messages

        # Notification for download starting
        # The -s silences curl's progress meter.
        # Redirect stdout and stderr to /dev/null to not clutter the terminal.
        # If curl fails, a message is printed to stderr.
        curl -s $ntfy_auth_header \
             -H "Title: yt-dlp Download Starting" \
             -H "Tags: hourglass" \
             -H "Priority: low" \
             -d "yt-dlp process started for: $args_string" \
             "$ntfy_server/$ntfy_topic" > /dev/null 2>&1 || echo "ntfy [START] notification failed for '$args_string'. Check topic/server/auth." >&2

        # Your original yt-dlp command with its fixed options,
        # plus any arguments passed to the 'yt' alias ("$@").
        # The "--cookies cookies.txt" part is from your original alias.
        # This means yt-dlp will look for "cookies.txt" in the current working directory.
        # If you have a fixed cookie file (e.g., in ~/.config/yt-dlp/cookies.txt),
        # you might remove "--cookies cookies.txt" if yt-dlp is configured to find it,
        # or change it to an absolute path, e.g., "--cookies ${HOME}/.config/yt-dlp/cookies.txt".
        yt-dlp --retries infinite \
               --fragment-retries infinite \
               --socket-timeout 90 \
               --cookies /home/ham/cookies.txt \
               "$@"
        local exit_status=$? # Capture the exit status of yt-dlp

        if [ $exit_status -eq 0 ]; then
            # Notification for download finishing successfully
            curl -s $ntfy_auth_header \
                 -H "Title: yt-dlp Download Successful" \
                 -H "Tags: white_check_mark" \
                 -H "Priority: default" \
                 -d "yt-dlp process finished successfully for: $args_string" \
                 "$ntfy_server/$ntfy_topic" > /dev/null 2>&1 || echo "ntfy [SUCCESS] notification failed for '$args_string'." >&2
        else
            # Notification for download finishing with an error
            curl -s $ntfy_auth_header \
                 -H "Title: yt-dlp Download Failed" \
                 -H "Tags: x" \
                 -H "Priority: high" \
                 -d "yt-dlp process failed for: $args_string (Exit code: $exit_status)" \
                 "$ntfy_server/$ntfy_topic" > /dev/null 2>&1 || echo "ntfy [FAILED] notification failed for '$args_string'." >&2
        fi

        return $exit_status # Return the original exit status of yt-dlp
    }

    # Alias 'yt' to your new function
    alias yt='_yt_with_ntfy'
  '';

  # For Zsh users:
  # If you use Zsh, you can put the same content in programs.zsh.initExtra:
  # programs.zsh.initExtra = programs.bash.initExtra;

  # Note on cookies.txt:
  # The function above uses "--cookies cookies.txt", meaning yt-dlp expects this file
  # in the directory where you run the 'yt' command.
  # If you prefer a central cookie file, you could:
  # 1. Manage it with home-manager:
  #    home.file.".config/yt-dlp/cookies.txt".source = /path/to/your/actual/cookies_file;
  # 2. Then, either remove "--cookies cookies.txt" from the yt-dlp command in the function
  #    (yt-dlp often checks ~/.config/yt-dlp/cookies.txt by default)
  #    or change it to "--cookies ''${XDG_CONFIG_HOME:-$HOME/.config}/yt-dlp/cookies.txt".
}