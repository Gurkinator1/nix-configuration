{ pkgs, ... }: {
    users.users.gurki = {
        packages = with pkgs; [
            git
            gh
        ];
    }
}