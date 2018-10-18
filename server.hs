import Network.Transport.TCP (createTransport, defaultTCPParameters)
import Control.Distributed.Process
import Control.Distributed.Process.Node


main :: IO ()
main = do
  Right transport <- createTransport "127.0.0.1" "4001" defaultTCPParameters
  node <- newLocalNode transport initRemoteTable
  _ <- runProcess node $ do
    -- get the id of this process
    self <- getSelfPid
    send self "Talking to myself"
    message <- expect :: Process String
    liftIO $ putStrLn message
  return ()

  defaultTCPParameters :: TCPParameters
  defaultTCPParameters = TCPParameters {
    tcpBacklog         = N.sOMAXCONN
  , tcpReuseServerAddr = True
  , tcpReuseClientAddr = True
  , tcpNoDelay         = False
  , tcpKeepAlive       = False
  , tcpUserTimeout     = Nothing
  , tcpNewQDisc        = simpleUnboundedQDisc
  , transportConnectTimeout = Nothing
  , tcpMaxAddressLength = maxBound
  , tcpMaxReceiveLength = maxBound
  , tcpCheckPeerHost   = False
  }