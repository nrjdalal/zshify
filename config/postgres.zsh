pglaunch() {
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
    # name for postgres container
    -n | --name)
      name="$2"
      if [[ -z "$name" ]]; then
        echo "-n or --name option requires an argument"
        exit 1
      fi
      shift 2
      ;;

    # port for postgres container
    -p | --port)
      port="$2"
      if [[ -z "$port" ]]; then
        echo "-p or --port option requires an argument"
        exit 1
      fi
      shift 2
      ;;

    *)
      echo "Unknown option: $1"
      exit 1
      ;;
    esac
  done

  echo

  # if name is not provided, assign current directory name
  if [[ -z "$name" ]]; then
    name="$(basename $(pwd))"
  fi

  # if port is not provided, prompt for it
  if [[ -z "$port" ]]; then
    tput setaf 3
    echo -n "enter port for access (enter for default i.e. 5432): "
    tput sgr0
    read port
    if [[ -z "$port" ]]; then
      port="5432"
    fi
    echo
  fi

  # final variables with modifications if any
  name="$name-$(openssl rand -base64 3 | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | head -c 4)"
  port="$port"
  pguname="postgres"
  pgupass="$(openssl rand -base64 12 | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | head -c 12)"
  pgdname="postgres"
  existing=$(docker ps -a | grep 5432 | awk '{print $1}' | head -n 1)

  if [[ -n "$existing" ]]; then
    tput setaf 5
    echo "> docker rm -f $existing"
    tput sgr0
    docker rm -f $existing
    echo
  fi

  tput setaf 5
  echo "> docker run --name $name -e POSTGRES_USER=$pguname -e POSTGRES_PASSWORD=$pgupass -e POSTGRES_DB=$pgdname -p $port:5432 -d --rm postgres:alpine"
  tput sgr0
  docker run --name $name -e POSTGRES_USER=$pguname -e POSTGRES_PASSWORD=$pgupass -e POSTGRES_DB=$pgdname -p $port:5432 -d --rm postgres:alpine
  echo

  tput setaf 14
  echo "POSTGRES_URL=postgresql://$pguname:$pgupass@localhost:$port/$pgdname"
  tput sgr0
}
