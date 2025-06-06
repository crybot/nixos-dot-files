{ config, pkgs, lib, ...}:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';

    functions = {
      fish_prompt = {
        description = "Write out the prompt";
        body = builtins.readFile ./fish_prompt.fish;
      };
    };
  };
}
