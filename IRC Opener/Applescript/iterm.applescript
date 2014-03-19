set irc to "IRC_COMMAND_PLACEHOLDER"
tell application "iTerm"
	activate
	if not (the current terminal exists) then
		set term to (make new terminal)
	else
		set term to (the current terminal)
	end if
	tell term
		tell (make new session)
			set name to "IRC"
			exec command irc
		end tell
	end tell
end tell