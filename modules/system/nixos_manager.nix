{ pkgs, ... }:

let
  GROUP = "nixos_manager";
in
{
  users.groups.${GROUP} = {};

  system.activationScripts.nixosManagerPerms = {
    # Ensure this script runs after users and groups are set up by the system
    deps = [ "users" "groups" ];
    
    text = ''
      # Set ownership
      ${pkgs.coreutils}/bin/chown -R root:${GROUP} /etc/nixos

      # Set read/write for group, and apply +X 
      ${pkgs.coreutils}/bin/chmod -R g+rwX /etc/nixos

      # Set SGID bit on all directories so new files inherit the group
      ${pkgs.findutils}/bin/find /etc/nixos -type d -exec ${pkgs.coreutils}/bin/chmod g+s {} +

      # Apply ACLs to guarantee group write access on newly created files
      # -m g:GROUP:rwX   = modifies current permissions
      # -m d:g:GROUP:rwX = sets the default permissions for new items
      ${pkgs.acl}/bin/setfacl -R -m g:${GROUP}:rwX,d:g:${GROUP}:rwX /etc/nixos
    '';
  };
}
