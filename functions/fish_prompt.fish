function fish_prompt
  # Save the status code from the previous command.
  set -l IFS ''

  set -q chain_prompt_glyph
    or set chain_prompt_glyph ">"

  # If links aren't configured, set the defaults.
  set -q chain_links
    or chain.defaults

  # Compile the prompt if it is not already.
  type -fq __chain_compiled_prompt
    or chain.compile

  # Display all links.
  if set -q chain_multiline
    printf '┌%s\n└' (__chain_compiled_prompt)
  else
    printf '%s-' (__chain_compiled_prompt)
  end

  echo -n "$chain_prompt_glyph "

  builtin set_color normal 2> /dev/null
end
