# parse the text

# top - 09:46:57 up 11 days, 22:54,  0 user,  load average: 0.41, 0.49, 0.41
# Tasks:   2 total,   1 running,   1 sleeping,   0 stopped,   0 zombie
# %Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st 
# KiB Mem :  8039820 total,   239368 free,  6865772 used,  1306176 buff/cache     
# KiB Swap:  1048572 total,        0 free,  1048572 used.  1174048 avail Mem 
# 
#   PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
#     1 root      20   0    4056   3176   2652 S   0.0   0.0   0:00.04 bash
#   210 root      20   0    8420   4256   2380 R   0.0   0.1   0:00.00 top

BEGIN {
  if (FORMAT=="TSV") {
    SeparatedValue="\t"
  } else {
    SeparatedValue=","
  }
}

# top - 09:46:57 up 11 days, 22:54,  0 user,  load average: 0.41, 0.49, 0.41
/^top - / {
  add_param("time", $3)
  add_param("load_average_1min", substr($12, 1, length($12) - 1))
  add_param("load_average_5min", substr($13, 1, length($13) - 1))
  add_param("load_average_15min", $14)
}

# Tasks:   2 total,   1 running,   1 sleeping,   0 stopped,   0 zombie
/^Tasks: /{
  add_param("task_total", $2)
  add_param("task_running", $4)
  add_param("task_sleeping", $6)
  add_param("task_stopped", $8)
  add_param("task_zombie", $10)
}

# %Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st 
/^%Cpu\(s\): / {
  add_param("cpu_us", $2)
  add_param("cpu_sy", $4)
  add_param("cpu_ni", $6)
  add_param("cpu_id", $8)
  add_param("cpu_wa", $10)
  add_param("cpu_hi", $12)
  add_param("cpu_si", $14)
  add_param("cpu_st", $16)
}
# KiB Mem :  8039820 total,   239368 free,  6865772 used,  1306176 buff/cache     
/^KiB Mem : / {
  add_param("mem_total", $4)
  add_param("mem_free", $6)
  add_param("mem_used", $8)
  add_param("mem_buff/cache", $10)
}
# KiB Swap:  1048572 total,        0 free,  1048572 used.  1174048 avail Mem 
/^KiB Swap: / {
  add_param("swap_total", $3)
  add_param("swap_free", $5)
  add_param("swap_used", $7)
  add_param("swap_avail_mem", $9)
}

# /^[ ]*PID USER/ {
#   IN_PROCESS_LIST=1
# }
# /^$/ {
#   IN_PROCESS_LIST=0
# }

END {
  print_all_params()
}

function add_param(profile_type, param,     l) {
  l = 1 + profiles_length[profile_type]
  profiles_length[profile_type] = l
  profiles[profile_type,l] = param
}

function print_all_params() {
  print_params("time")
  print_params("load_average_1min")
  print_params("load_average_5min")
  print_params("load_average_15min")
  print_params("task_total")
  print_params("task_running")
  print_params("task_sleeping")
  print_params("task_stopped")
  print_params("task_zombie")
  print_params("cpu_us")
  print_params("cpu_sy")
  print_params("cpu_ni")
  print_params("cpu_id")
  print_params("cpu_wa")
  print_params("cpu_hi")
  print_params("cpu_si")
  print_params("cpu_st")
  print_params("mem_total")
  print_params("mem_free")
  print_params("mem_used")
  print_params("mem_buff/cache")
  print_params("swap_total")
  print_params("swap_free")
  print_params("swap_used")
  print_params("swap_avail_mem")
  # for(profile_type in profiles)
  #   print_params(profile_type)
}

function print_params(profile_type) {
  printf profile_type SeparatedValue

  for(i=1;i<=profiles_length[profile_type];i++) {
    if (i>1) {
      printf SeparatedValue
    }
    printf profiles[profile_type,i]
  }
  printf "\n"
}
