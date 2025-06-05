{ pkgs, config, ... }: # Your existing home.nix arguments

{

  # 2. Configure Bash
  programs.bash.initExtra = ''
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
        curl -s $ntfy_auth_header \
             -H "Title: yt-dlp Download Starting" \
             -H "Tags: hourglass" \
             -H "Priority: low" \
             -d "yt-dlp process started for: $args_string" \
             "$ntfy_server/$ntfy_topic" > /dev/null 2>&1 || echo "ntfy [START] notification failed for '$args_string'. Check topic/server/auth." >&2

        # Your original yt-dlp command
        yt-dlp --retries infinite \
               --fragment-retries infinite \
               --socket-timeout 90 \
               --cookies cookies.txt \
               "$@"
        local exit_status=$?

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

        return $exit_status
    }

    # Alias 'yt' to your new function
    alias yt='_yt_with_ntfy'
  ''; # End of programs.bash.initExtra

  # For Zsh users:
  # If you use Zsh, you can put the same content in programs.zsh.initExtra:
  # programs.zsh.initExtra = programs.bash.initExtra; # If you've defined it as above

  # Corrected notes on cookies.txt for Nix parsing:
  # The comments below are illustrative of how to properly escape shell variables
  # if you were to put them directly in the Nix string (e.g. in an active command).
  # The actual command in the function above currently uses "--cookies cookies.txt".

  # Example of how you would write a command using HOME or XDG_CONFIG_HOME
  # if it were directly in the Nix string and meant for shell expansion:
  # some_command --config-file "''${XDG_CONFIG_HOME:-''${HOME}/.config}/someapp/config"

  # Note on cookies.txt: (This is primarily for your understanding of the escaping)
  # The function above uses "--cookies cookies.txt", meaning yt-dlp expects this file
  # in the directory where you run the 'yt' command.
  # If you prefer a central cookie file, you could:
  # 1. Manage it with home-manager (this is a Nix-level configuration):
  #    home.file.".config/yt-dlp/cookies.txt".source = /path/to/your/actual/cookies_file;
  # 2. Then, in the bash function, you could either:
  #    a) Remove "--cookies cookies.txt" (yt-dlp often checks ''${XDG_CONFIG_HOME:-''${HOME}/.config}/yt-dlp/cookies.txt by default).
  #    b) Change the command to explicitly use the path, e.g.,
  #       yt-dlp ... --cookies "''${XDG_CONFIG_HOME:-''${HOME}/.config}/yt-dlp/cookies.txt" "$@"
  #       The line that caused your error was a comment suggesting:
  #       "--cookies ''${HOME}/.config/yt-dlp/cookies.txt"
  #       This is the correctly escaped version for Nix.
}