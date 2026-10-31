#sets up a rex server in login-mode
{
  #tailscale enabled in @tailscale.nix. This config option stays
  #within tailscale.nix for restriction clarity
  services.rex.enable = false;
  users.users.dio.isNormalUser = true;

  services.rex.loginServer = {
    enable = true;
    accounts.dio.principals = [ "tailscale:dioeeos@gmail.com" ];
    tailscaleServe.enable = true;
  };
}
