import Control.Monad (when, void)
import Discord
import Discord.Types
import qualified Discord.Requests as R

import Text.Regex.Base
import Text.Regex.Posix 

import Data.Text
import  qualified Data.List 
import Data.Text.IO

import System.Environment
import Data.List (union)

mtoken :: IO Text
mtoken = do
    args <- getArgs
    return (pack $ Data.List.head args)

muser :: IO Text
muser = do 
    args <- getArgs
    return (pack $ Data.List.last args)

nyabot :: IO ()
nyabot = do
    token <- mtoken -- get the tooken and username from args
    user <- muser
    userFacingError <- runDiscord $ def -- start the discord bot with arguments
        {
        discordToken = token
        ,discordOnEvent = eventHandler user
        ,discordOnLog = Data.Text.IO.putStrLn
        ,discordOnEnd = Prelude.putStrLn "ended"
        }
    
    Data.Text.IO.putStrLn userFacingError


eventHandler :: Text -> Event -> DiscordHandler ()
eventHandler user event = case event of 
    MessageCreate message -> when (isfromUser message user && not (fromBot message) && not (escapeFlags message) ) $ do
        nyafication message
    _ -> return ()

-- is message is from user and not from bot and not has escapeflags 
-- > if message does contain command 
--  > do command 
-- > do nyafication

--check if message is from the bot
fromBot :: Message -> Bool
fromBot = userIsBot.messageAuthor

-- check if the message is from user we need
isfromUser :: Message -> Text -> Bool
isfromUser m u = userName ( messageAuthor m) == u 

nyafication :: Message -> DiscordHandler ()
nyafication m = do
    let mv = m --save the message for later use
    void $ restCall (R.DeleteMessage ( messageChannelId m , messageId m ) ) -- delete the original message
    void $ restCall (R.CreateMessage ( messageChannelId mv ) ( addnya $ messageContent mv )) -- add nya to the original message and send it

addnya :: Text -> Text
addnya m = replace (pack (unpack m =~ "([',?!.;:\"])$") ) ( pack ( unpack m =~ ",nya\1") ) m

escapeFlags :: Message -> Bool
escapeFlags m 
  | Data.Text.isPrefixOf (pack "nya") (messageContent m) = False
  | Data.Text.isPrefixOf (pack "https://") (messageContent m) = False 
  | hasAttachments m = False
  | otherwise = True

hasAttachments :: Message -> Bool
hasAttachments m = Data.List.null $ messageAttachments m 


