import 'package:flutter_pcsc_platform_interface/flutter_pcsc_platform_interface.dart';
import 'package:flutter_pcsc_windows/src/pcsc_bindings.dart';

/// The main class to use to deal with PCSC.
class PcscWindows extends PcscPlatform {
  static void registerWith() {
    PcscPlatform.instance = PcscWindows();
  }

  static final PCSCBinding _binding = PCSCBinding();

  /*
   * Not really asynchronous (the C call is synchronous), but it will be easier to use if a Future is returned
   */
  /// Establishes a PCSC context.
  @override
  Future<int> establishContext(int scope) {
    return _binding.establishContext(scope);
  }

  /// Lists available readers for this context.
  @override
  Future<List<String>> listReaders(int context) {
    return _binding.listReaders(context);
  }

  /// Connects to the card using the specified reader.
  @override
  Future<Map> cardConnect(
      int context, String reader, int shareMode, int protocol) {
    return _binding.cardConnect(context, reader, shareMode, protocol);
  }

  /// Reset Card
  @override
  Future<List<int>> reset(int hCard, bool cold) {
    int protocol = 3; // T0 | T1
    return _binding.reset (hCard, protocol, cold);
  }

  /// Transmits an APDU to the card.
  @override
  Future<List<int>> transmit(
      int hCard, int activeProtocol, List<int> commandBytes,
      {bool newIsolate = false}) {
    return _binding.transmit(hCard, activeProtocol, commandBytes,
        newIsolate: newIsolate);
  }

  /// Transmits an APDU to the ccid-ifd.
  @override
  Future<List<int>> escapeCommand(
      int hCard, List<int> commandBytes, { bool newIsolate = false}) {
    return _binding.escapeCommand(hCard, commandBytes, newIsolate: newIsolate);
  }

  /// Disconnects from the card.
  @override
  Future<void> cardDisconnect(int hCard, int disposition) {
    return _binding.cardDisconnect(hCard, disposition);
  }

  /// Releases the PCSC context.
  @override
  Future<void> releaseContext(int context) {
    return _binding.releaseContext(context);
  }

  /// Waits for a card to be present on the specified reader.
  ///
  /// If a card is already present, it does not wait.
  @override
  Future<Map> waitForCardPresent(int context, String readerName) {
    return _binding.waitForCardPresent(context, readerName);
  }

  /// Waits for a card to be removed on the specified reader.
  ///
  /// If a card is already removed, it does not wait.
  @override
  Future<void> waitForCardRemoved(int context, String readerName) {
    return _binding.waitForCardRemoved(context, readerName);
  }
}