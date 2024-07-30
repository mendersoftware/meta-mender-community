#!/bin/sh

function to_unicode() {
	local in="$1"
	local out

	for (( i=0; i<${#in}; i++)); do
		char=${in:i:1}
		out+="$char"
		out+="\x00"
	done
	echo -n "$out"
}


function fill_to_size() {
	local size="$2"
	local out="$1"	
	local fill_size=$(( $size - (${#out}*2/5) ))

	for i in $(seq $fill_size)
	do
		out+="\x00"
	done

	echo -n "$out"
}


function write_efivar() {
	local readonly varname="781e084c-a330-417c-b678-38e696380cb9-KernelCommandLine"
	local readonly total_size=514
	local readonly attr_size=4
	local readonly data_size=$(( $total_size - $attr_size))
	local in="$1"

	#printf "\nin=$in\n"
	local out="$(to_unicode "$in")"	
	out="$(fill_to_size "$out" $data_size)"

	local f=$(mktemp)
	printf "$out" > $f
	efivar -n $varname -f $f -w 
	rm ${f}
}

function read_efivar() {
	local readonly varname="/sys/firmware/efi/efivars/KernelCommandLine-781e084c-a330-417c-b678-38e696380cb9"
	local var=$(cat $varname | tail -c +5 | tr -d '[\000]')

	echo -n "$var"
}


function read_efi_machine_id() {
	local var=$(read_efivar)
	local id
	
	for i in $var; do
		case $i in 
			systemd.machine_id=*)
				id="${i#*=}"
				;;
			*)
				;;
		esac
	done
	echo -n "$id"
}


function write_efi_machine_id() {
	local id="$1"
	local var=$(read_efivar)
	local out_var
	local sep=""
	local id_mod=false

	for i in $var; do
		out_var+="$sep"
		case $i in 
			systemd.machine_id=*)
				out_var+="systemd.machine_id=$id"
				id_mod=true
				;;
			*)
				out_var+="$i"
				;;
		esac
		sep=" "
	done
	
	if [ "$id_mod" = false ] ; then
		out_var+="${sep}systemd.machine_id=$id"
	fi

	write_efivar "$out_var"	
}


usage="Usage: efi_systemd_machine_id.sh [-r] [-w val]"

while getopts "rw:" opt; do
  case ${opt} in
    r )
	printf "$(read_efi_machine_id)\n"
      ;;
    w )
	write_efi_machine_id $OPTARG 
      ;;
    \? ) 
	echo "$usage";exit 2
      ;;
  esac
done


if [ $OPTIND -eq 1 ]; then 
	echo "$usage"; exit 1 
fi








