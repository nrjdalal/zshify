pglaunch() {
  echo

  name=""
  port=""
  keep="--rm"

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
    # name for docker container (default: current directory name)
    -n | --name)
      name="$2"
      if [[ -z "$name" ]]; then
        echo "-n or --name option requires an argument"
        return 1
      fi
      shift 2
      ;;

    # port for postgres container (default: 5555)
    -p | --port)
      port="$2"
      if [[ -z "$port" ]]; then
        echo "-p or --port option requires an argument"
        return 1
      fi
      shift 2
      ;;

    -k | -keep)
      keep=""
      shift 1
      ;;

    -h | --help)
      echo "Usage: pglaunch [options]"
      echo
      echo "Options:"
      echo "  -n, --name <name>    name for docker container (default: current directory name)"
      echo "  -p, --port <port>    port for postgres container (default: 5555)"
      echo "  -k, --keep           keep postgres container after restart or return"
      echo "  -h, --help           show this help message"
      echo "  -v, --version        show version"
      return 0
      ;;

    -v | --version)
      echo "pglaunch version 2.19.0"
      return 0
      ;;

    *)
      echo "Unknown option: $1"
      echo "Try pglaunch --help for more information."
      return 1
      ;;
    esac
  done

  # check if docker is installed
  which docker &>/dev/null || {
    tput setaf 1
    echo "Docker is not installed. Please install docker and try again."
    echo "https://docs.docker.com/get-docker"
    tput sgr0
    return 1
  }

  # check if docker is running
  docker info &>/dev/null
  [[ $? -eq 1 ]] && {
    tput setaf 1
    echo "Docker is not running. Please start docker and try again."
    tput sgr0
    return 1
  }

  # set defaults if not provided
  [[ -z "$name" ]] && name="$(basename $(pwd))"
  [[ -z "$port" ]] && port="5555"

  name="$name-$(openssl rand -base64 3 | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | head -c 4)"
  port="$port"
  pguname="postgres"
  pgupass="$(openssl rand -base64 12 | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | head -c 12)"
  pgdname="postgres"

  # check if postgres container is already running
  existing=$(docker ps -a | grep ":$port" | awk '{print $1}' | head -n 1)
  [[ -n "$existing" ]] && docker rm -f $existing &>/dev/null

  # run postgres container
  docker run --name $name -e POSTGRES_USER=$pguname -e POSTGRES_PASSWORD=$pgupass -e POSTGRES_DB=$pgdname -p $port:5432 -d $keep postgres:alpine &>/dev/null

  echo "POSTGRES_URL=$(tput setaf 14)postgresql://$pguname:$pgupass@localhost:$port/$pgdname$(tput sgr0)"
}
