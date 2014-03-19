set irc to "IRC_COMMAND_PLACEHOLDER"
tell application "iTerm"
	activate
    tell (make new terminal)
		tell (make new session)
			set name to "IRC"
			exec command irc
		end tell
	end tell
end tell