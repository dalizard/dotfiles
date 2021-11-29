function fssh --description "Fuzzy-find ssh host and ssh into it"
  rg '^Host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf --height 10% | xargs -o ssh
end

function tunup --description "Initialize SSH tunnel for exposing local web servers"
  set port $argv
	echo "Forwarding rb.forebits.com:5000 to local port $port"
	ssh -R 5000:127.0.0.1:$port gollum
end
