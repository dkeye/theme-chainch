#############################
# => Command duration segment
#############################

function __chainch_cmd_duration -d 'Displays the elapsed time of last command'
  set -l seconds ''
  set -l minutes ''
  set -l hours ''
  set -l days ''

  set -l cmd_duration (math -s0 $CMD_DURATION / 1000)
  if [ $cmd_duration -gt 0 ]
    set seconds (math -s0 $cmd_duration % 60)'s'
    if [ $cmd_duration -ge 60 ]
      set minutes (math -s0 $cmd_duration % 3600 / 60)'m'
      if [ $cmd_duration -ge 3600 ]
        set hours (math -s0 $cmd_duration % 86400 / 3600)'h'
        if [ $cmd_duration -ge 86400 ]
          set days (math -s0 $cmd_duration / 86400)'d'
        end
      end
    end
    set_color $chainch_colors[2]
        if [ $status -ne 0 ]
          echo -n (set_color -b $chainch_colors[2] $chainch_colors[7])''$days$hours$minutes$seconds' '
        else
          echo -n (set_color -b $chainch_colors[2] $chainch_colors[12])''$days$hours$minutes$seconds' '
        end
    set_color -b $chainch_colors[2]
  end
end

################
# => PWD segment
################
function __chainch_prompt_pwd -d 'Displays the present working directory'
  set -l user_host ' '
  if set -q SSH_CLIENT
    if [ $symbols_style = 'symbols' ]
      switch $pwd_style
        case short
          set user_host " $USER@"(hostname -s)':'
        case long
          set user_host " $USER@"(hostname -f)':'
      end
    else
      set user_host " $USER@"(hostname -i)':'
    end
  end
  set_color -b $chainch_colors[2] $chainch_colors[12]
  echo -n ''
  set_color normal
  set_color -b $chainch_colors[2] $chainch_colors[1]
  if [ (count $chainch_prompt_error) != 1 ]
    switch $pwd_style
      case short
        echo -n $user_host(prompt_pwd)' '
      case long
        echo -n $user_host(pwd)' '
    end
  else
    echo -n " $chainch_prompt_error "
    set -e chainch_prompt_error[1]
  end
  set_color normal
end

function __chainch_right_status
  set -l exit_code $status
  set_color $chainch_colors[2]
  echo -n ''
  if test $exit_code -ne 0
    set_color -b $chainch_colors[2] red
    echo -n '✖ '
  else
    set_color -b $chainch_colors[2] green
    echo -n '✓ '
  end

  set_color normal
end


###############################################################################
# => Prompt
###############################################################################

function fish_right_prompt -d 'Write out the right prompt of the chainch theme'
  echo -n -s (__chainch_right_status) (__chainch_cmd_duration) (__chainch_prompt_pwd)
  set_color normal
end
