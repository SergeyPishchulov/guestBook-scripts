$vmexternalip = $args[0]
ssh yc-user@$vmexternalip 'sudo kill -INT "$(pgrep uvicorn)"; echo killed; cd guestBook-backend; git pull; sudo uvicorn main:app --host 0.0.0.0 --port 80'