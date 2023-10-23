BEGIN {
  if (FORMAT=="TSV") {
    SeparatedValue="\t"
  } else {
    SeparatedValue=", "
  }
}

/^%Cpu\(s\): / {
  add_param("cpu_user", $2)
  add_param("cpu_system", $4)
}
/^MiB Mem : / {
  add_param("memory_total", $4)
  add_param("memory_free", $6)
  add_param("memory_used", $8)
}

END {
  print_all_params()
}

function add_param(profile_type, param) {
  profiles[profile_type][length(profiles[profile_type]) + 1] = param
}

function print_all_params() {
  for(profile_type in profiles)
    print_params(profile_type)
}

function print_params(profile_type) {
  printf profile_type SeparatedValue
  print_arr(profiles[profile_type])
}

function print_arr(arr) {
  for(i=1;i<=length(arr);i++) {
    if (i>1) {
      printf SeparatedValue
    }
    printf arr[i]
  }
  printf "\n"
}
