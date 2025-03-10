package dev.hebei.wifi

import android.net.DhcpInfo

class DhcpInfoApi(registrar: WifiPigeonProxyApiRegistrar) : PigeonApiDhcpInfo(registrar) {
    override fun getDNS1(pigeon_instance: DhcpInfo): Long {
        return pigeon_instance.dns1.toLong()
    }

    override fun getDNS2(pigeon_instance: DhcpInfo): Long {
        return pigeon_instance.dns2.toLong()
    }

    override fun getGateway(pigeon_instance: DhcpInfo): Long {
        return pigeon_instance.gateway.toLong()
    }

    override fun getIpAddress(pigeon_instance: DhcpInfo): Long {
        return pigeon_instance.ipAddress.toLong()
    }

    override fun getLeaseDuration(pigeon_instance: DhcpInfo): Long {
        return pigeon_instance.leaseDuration.toLong()
    }

    override fun getNetmask(pigeon_instance: DhcpInfo): Long {
        return pigeon_instance.netmask.toLong()
    }

    override fun getServerAddress(pigeon_instance: DhcpInfo): Long {
        return pigeon_instance.serverAddress.toLong()
    }
}