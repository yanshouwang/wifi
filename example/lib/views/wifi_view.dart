import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:wifi_example/view_models.dart';

class WiFiView extends StatelessWidget with TypeLogger {
  const WiFiView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<WiFiViewModel>(context);
    final state = viewModel.enabled;
    final configuredNetworks = viewModel.configuredNetworks;
    for (var network in configuredNetworks) {
      logger.info(
          'configured network: ${network.networkId}, ${network.ssid}, ${network.status}');
    }
    final scanResults = viewModel.scanResults;
    final connectionInfo = viewModel.connectionInfo;
    logger.info(
        'connection info: ${connectionInfo.ssid}, ${connectionInfo.linkSpeed}');
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('WiFi'),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: SwitchListTile(
              title: const Text('WiFi'),
              value: state,
              onChanged: (value) => viewModel.enabled = value,
            ),
          ),
          SliverList.separated(
            itemBuilder: (context, index) {
              final wc = configuredNetworks[index];
              return ListTile(
                title: Text(wc.ssid),
                onTap: () => viewModel.connect(wc.networkId),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: configuredNetworks.length,
          ),
          SliverList.separated(
            itemBuilder: (context, index) {
              final sr = scanResults[index];
              return ListTile(
                title: Text(sr.ssid),
                subtitle: Text(sr.bssid),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: scanResults.length,
          ),
        ],
      ),
    );
  }
}
