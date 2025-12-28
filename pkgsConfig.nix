{ config, lib, ... }:

{
    nixpkgs.config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
    };
}
