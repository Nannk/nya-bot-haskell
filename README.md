# nya-bot-haskell
A rewrite of my python bot (https://github.com/Nannk/bots) 
> simple bot that adds `nya~` to the end of each message for a selected user.

# How to use

for now the bots have limitations:
- you cant answer to the messages (use @username instead)
- if someone pings(answers) the bot you wont be notified
- currently there is no way to edit your message if the bot has modified it.
- the bots dont reflect the users status
- add users takes time bc each user has its own individual bot (also litters the server)
- bots ignore :
  - Messages that starts with `\>`or `nya`
  - Messages with attachments
  - Messages with custom escape characters (like `https://cdn.discordapp.com/emojis/`)

# Not yet implemented in this rewrite:
- to change the pfp use `nya|pfpchange|<link_to_the_new_profile_picture>`
- by sending ` nya|toggle`  you can enable random nya mode. It adds nyas to you message in random places
