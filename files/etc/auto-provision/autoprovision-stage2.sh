#!/bin/bash

# autoprovision stage 2: this script will be executed upon boot if the extroot was successfully mounted (i.e. rc.local is run from the extroot overlay)

. /etc/auto-provision/autoprovision-functions.sh

# Command to check if a command ran successfully
check_run() {
    if eval "$@"; then
        return 0  # Command ran successfully, return true
    else
        return 1  # Command failed to run, return false
    fi
}

# Log to the system log and echo if needed
log_say()
{
    SCRIPT_NAME=$(basename "$0")
    echo "${SCRIPT_NAME}: ${1}"
    logger "${SCRIPT_NAME}: ${1}"
}

# Command to wait for Internet connection
wait_for_internet() {
    while ! ping -q -c3 1.1.1.1 >/dev/null 2>&1; do
        log_say "Waiting for Internet connection..."
        sleep 1
    done
    log_say "Internet connection established"
}

# Command to wait for opkg to finish
wait_for_opkg() {
  while pgrep -x opkg >/dev/null; do
    log_say "Waiting for opkg to finish..."
    sleep 1
  done
  log_say "opkg is released, our turn!"
}

installPackages()
{
    signalAutoprovisionWaitingForUser

    until (opkg update)
    do
        log_say "opkg update failed. No internet connection? Retrying in 15 seconds..."
        sleep 15
    done

    signalAutoprovisionWorking

    log_say "Autoprovisioning stage2 is about to install packages"

    # CUSTOMIZE
    # install some more packages that don't need any extra steps
    log_say "updating all packages!"

    log_say "                                                                      "
    log_say " ███████████             ███                         █████            "
    log_say "░░███░░░░░███           ░░░                         ░░███             "
    log_say " ░███    ░███ ████████  ████  █████ █████  ██████   ███████    ██████ "
    log_say " ░██████████ ░░███░░███░░███ ░░███ ░░███  ░░░░░███ ░░░███░    ███░░███"
    log_say " ░███░░░░░░   ░███ ░░░  ░███  ░███  ░███   ███████   ░███    ░███████ "
    log_say " ░███         ░███      ░███  ░░███ ███   ███░░███   ░███ ███░███░░░  "
    log_say " █████        █████     █████  ░░█████   ░░████████  ░░█████ ░░██████ "
    log_say "░░░░░        ░░░░░     ░░░░░    ░░░░░     ░░░░░░░░    ░░░░░   ░░░░░░  "
    log_say "                                                                      "
    log_say "                                                                      "
    log_say " ███████████                        █████                             "
    log_say "░░███░░░░░███                      ░░███                              "
    log_say " ░███    ░███   ██████  █████ ████ ███████    ██████  ████████        "
    log_say " ░██████████   ███░░███░░███ ░███ ░░░███░    ███░░███░░███░░███       "
    log_say " ░███░░░░░███ ░███ ░███ ░███ ░███   ░███    ░███████  ░███ ░░░        "
    log_say " ░███    ░███ ░███ ░███ ░███ ░███   ░███ ███░███░░░   ░███            "
    log_say " █████   █████░░██████  ░░████████  ░░█████ ░░██████  █████           "
    log_say "░░░░░   ░░░░░  ░░░░░░    ░░░░░░░░    ░░░░░   ░░░░░░  ░░░░░            "

    # Keep trying to run opkg update until it succeeds
    while ! check_run "opkg update"; do
        log_say "\"opkg update\" failed. Retrying in 15 seconds..."
        sleep 15
    done

    #mesh time
       opkg update
   #install mesh support
   opkg remove wpad
   opkg remove wpad wpad-basic
   opkg remove wpad-basic-openssl
   opkg remove wpad-basic-wolfssl
   opkg remove wpad-wolfssl
   opkg install wpad-mesh-openssl
   opkg install kmod-batman-adv
   opkg install batctl
   opkg install avahi-autoipd
    
    # List of our packages to install
    local PACKAGE_LIST="base-files busybox ca-bundle cgi-io dnsmasq dropbear firewall fstools fwtool getrandom hostapd-common ip6tables iptables iw iwinfo jshn jsonfilter kernel samba4-server luci-app-samba4 minidlna luci-app-minidlna kmod-ath kmod-ath9k kmod-ath9k-common kmod-cfg80211 kmod-gpio-button-hotplug kmod-ip6tables kmod-ipt-conntrack kmod-ipt-core kmod-ipt-nat kmod-ipt-offload kmod-lib-crc-ccitt kmod-mac80211 kmod-nf-conntrack kmod-nf-conntrack6 kmod-nf-flow kmod-nf-ipt kmod-nf-ipt6 kmod-nf-nat kmod-nf-reject kmod-nf-reject6 kmod-nls-base kmod-ppp kmod-pppoe kmod-pppox kmod-slhc kmod-usb-core kmod-usb-ehci libblobmsg-json20210516 libc libgcc1 libip4tc2 libip6tc2 libiwinfo-data libiwinfo-lua libiwinfo20210430 libjson-c5 libjson-script20210516 liblua5.1.5 liblucihttp-lua liblucihttp0 libnl-tiny1 libpthread libubox20210516 libubus-lua libubus20210630 libuci20130104 git git-http jq libuclient20201210 libustream-wolfssl20201210 libxtables12 logd lua luci luci-app-firewall luci-app-opkg luci-base luci-lib-base luci-lib-ip luci-lib-jsonc luci-lib-nixio luci-mod-admin-full luci-mod-network luci-mod-status luci-mod-system luci-proto-ipv6 luci-proto-ppp luci-ssl luci-theme-bootstrap luci-app-statistics luci-mod-dashboard luci-app-vnstat luci-app-openvpn wireguard-tools luci-app-wireguard openvpn-openssl mtd netifd odhcp6c odhcpd-ipv6only openwrt-keyring opkg ppp ppp-mod-pppoe procd px5g-wolfssl kmod-usb-storage block-mount kmod-fs-ext4 kmod-fs-exfat fdisk luci-compat luci-lib-ipkg curl bash wget kmod-usb-net-rndis luci-app-commands rpcd-mod-luci kmod-usb-net-cdc-eem kmod-usb-net-cdc-ether kmod-usb-net-cdc-subset kmod-usb-net kmod-usb2 kmod-usb-net-ipheth usbmuxd libimobiledevice usbutils luci-app-nlbwmon luci-app-adblock nano ttyd fail2ban speedtest-netperf vsftpd samba36-server luci-app-samba"

    count=$(echo "$PACKAGE_LIST" | wc -w)
    log_say "Packages to install: ${count}"

    # Convert the object list to an array
    IFS=' ' read -r -a objects <<< "$PACKAGE_LIST"

    # Loop until the object_list array is empty
    while [[ ${#objects[@]} -gt 0 ]]; do
        # Get a slice of 10 objects or the remaining objects if less than 10
        slice=("${objects[@]:0:10}")

        # Remove the echoed objects from the list
        objects=("${objects[@]:10}")

        # Join the slice into a single line with spaces
        line=$(printf "%s " "${slice[@]}")

        # Remove leading/trailing whitespaces
        line=$(echo "$line" | xargs)

        # opkg install the 10 packages
        eval "opkg install $line"
    done

   ## We have to remove dnsmasq (which is required to be installed on build) and install dnsmasq-full
   opkg remove dnsmasq
   # Get rid of the old dhcp config
   [ -f /etc/config/dhcp ] && rm /etc/config/dhcp
   # Install the dnsmasq-full package since we want that
   opkg install dnsmasq-full
   # Move the default dhcp config to the right place
   [ -f /etc/config/dhcp ] && mv /etc/config/dhcp /etc/config/dhcp.orig
   # Put our pre-configured config in its place
   [[ -f /etc/config/dhcp.pr && ! -f /etc/config/dhcp ]] && cp /etc/config/dhcp.pr /etc/config/dhcp

}

autoprovisionStage2()
{
    log_say "Autoprovisioning stage2 speaking"

    signalAutoprovisionWorking

    # CUSTOMIZE: with an empty argument it will set a random password and only ssh key based login will work.
    # please note that stage2 requires internet connection to install packages and you most probably want to log_say in
    # on the GUI to set up a WAN connection. but on the other hand you don't want to end up using a publically
    # available default password anywhere, therefore the random here...
    setRootPassword "torguard"

    installPackages

    chmod +x ${overlay_root}/etc/rc.local
    cat >${overlay_root}/etc/rc.local <<EOF
chmod a+x /etc/stage3.sh
{ bash /etc/stage3.sh; } && exit 0 || { log "** PRIVATEROUTER ERROR **: stage3.sh failed - rebooting in 30 seconds"; sleep 30; reboot; }
EOF

}

# Fix our DNS and update packages and do not check https certs
fixPackagesDNS()
{
    log_say "Fixing DNS (if needed) and installing required packages for opkg"

    # Domain to check
    domain="privaterouter.com"

    # DNS server to set if domain resolution fails
    dns_server="1.1.1.1"

    # Perform the DNS resolution check
    if ! nslookup "$domain" >/dev/null 2>&1; then
        log_say "Domain resolution failed. Setting DNS server to $dns_server."

        # Update resolv.conf with the new DNS server
        echo "nameserver $dns_server" > /etc/resolv.conf
    else
        log_say "Domain resolution successful."
    fi

    log_say "Installing opkg packages"
    opkg update --no-check-certificate
    opkg install --no-check-certificate wget-ssl unzip ca-bundle ca-certificates git git-http jq curl bash nano ntpdate

    # Set the time to fix ssl cert issues
    ntpdate -q 0.openwrt.pool.ntp.org
}

# Wait for Internet connection
wait_for_internet

# Wait for opkg to finish
wait_for_opkg

# Fix our DNS Server and install some required packages
fixPackagesDNS

autoprovisionStage2

reboot
