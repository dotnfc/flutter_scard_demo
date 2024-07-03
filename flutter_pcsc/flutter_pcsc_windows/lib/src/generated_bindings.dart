// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

/// Bindings to winscard.dll
class NativeLibraryWinscard {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeLibraryWinscard(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeLibraryWinscard.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  late final ffi.Pointer<SCARD_IO_REQUEST> _g_rgSCardT0Pci =
      _lookup<SCARD_IO_REQUEST>('g_rgSCardT0Pci');

  SCARD_IO_REQUEST get g_rgSCardT0Pci => _g_rgSCardT0Pci.ref;

  late final ffi.Pointer<SCARD_IO_REQUEST> _g_rgSCardT1Pci =
      _lookup<SCARD_IO_REQUEST>('g_rgSCardT1Pci');

  SCARD_IO_REQUEST get g_rgSCardT1Pci => _g_rgSCardT1Pci.ref;

  late final ffi.Pointer<SCARD_IO_REQUEST> _g_rgSCardRawPci =
      _lookup<SCARD_IO_REQUEST>('g_rgSCardRawPci');

  SCARD_IO_REQUEST get g_rgSCardRawPci => _g_rgSCardRawPci.ref;

  int SCardEstablishContext(
    int dwScope,
    LPCVOID pvReserved1,
    LPCVOID pvReserved2,
    LPSCARDCONTEXT phContext,
  ) {
    return _SCardEstablishContext(
      dwScope,
      pvReserved1,
      pvReserved2,
      phContext,
    );
  }

  late final _SCardEstablishContextPtr = _lookup<
      ffi.NativeFunction<
          LONG Function(DWORD, LPCVOID, LPCVOID,
              LPSCARDCONTEXT)>>('SCardEstablishContext');
  late final _SCardEstablishContext = _SCardEstablishContextPtr.asFunction<
      int Function(int, LPCVOID, LPCVOID, LPSCARDCONTEXT)>();

  int SCardReleaseContext(
    int hContext,
  ) {
    return _SCardReleaseContext(
      hContext,
    );
  }

  late final _SCardReleaseContextPtr =
      _lookup<ffi.NativeFunction<LONG Function(SCARDCONTEXT)>>(
          'SCardReleaseContext');
  late final _SCardReleaseContext =
      _SCardReleaseContextPtr.asFunction<int Function(int)>();

  int SCardIsValidContext(
    int hContext,
  ) {
    return _SCardIsValidContext(
      hContext,
    );
  }

  late final _SCardIsValidContextPtr =
      _lookup<ffi.NativeFunction<LONG Function(SCARDCONTEXT)>>(
          'SCardIsValidContext');
  late final _SCardIsValidContext =
      _SCardIsValidContextPtr.asFunction<int Function(int)>();

  int SCardListReaderGroupsA(
    int hContext,
    LPSTR mszGroups,
    LPDWORD pcchGroups,
  ) {
    return _SCardListReaderGroupsA(
      hContext,
      mszGroups,
      pcchGroups,
    );
  }

  late final _SCardListReaderGroupsAPtr =
      _lookup<ffi.NativeFunction<LONG Function(SCARDCONTEXT, LPSTR, LPDWORD)>>(
          'SCardListReaderGroupsA');
  late final _SCardListReaderGroupsA = _SCardListReaderGroupsAPtr.asFunction<
      int Function(int, LPSTR, LPDWORD)>();

  int SCardListReadersA(
    int hContext,
    LPCSTR mszGroups,
    LPSTR mszReaders,
    LPDWORD pcchReaders,
  ) {
    return _SCardListReadersA(
      hContext,
      mszGroups,
      mszReaders,
      pcchReaders,
    );
  }

  late final _SCardListReadersAPtr = _lookup<
      ffi.NativeFunction<
          LONG Function(
              SCARDCONTEXT, LPCSTR, LPSTR, LPDWORD)>>('SCardListReadersA');
  late final _SCardListReadersA = _SCardListReadersAPtr.asFunction<
      int Function(int, LPCSTR, LPSTR, LPDWORD)>();

  /// /////////////////////////////////////////////////////////////////////////////
  int SCardFreeMemory(
    int hContext,
    LPCVOID pvMem,
  ) {
    return _SCardFreeMemory(
      hContext,
      pvMem,
    );
  }

  late final _SCardFreeMemoryPtr =
      _lookup<ffi.NativeFunction<LONG Function(SCARDCONTEXT, LPCVOID)>>(
          'SCardFreeMemory');
  late final _SCardFreeMemory =
      _SCardFreeMemoryPtr.asFunction<int Function(int, LPCVOID)>();

  int SCardGetStatusChangeA(
    int hContext,
    int dwTimeout,
    LPSCARD_READERSTATEA rgReaderStates,
    int cReaders,
  ) {
    return _SCardGetStatusChangeA(
      hContext,
      dwTimeout,
      rgReaderStates,
      cReaders,
    );
  }

  late final _SCardGetStatusChangeAPtr = _lookup<
      ffi.NativeFunction<
          LONG Function(SCARDCONTEXT, DWORD, LPSCARD_READERSTATEA,
              DWORD)>>('SCardGetStatusChangeA');
  late final _SCardGetStatusChangeA = _SCardGetStatusChangeAPtr.asFunction<
      int Function(int, int, LPSCARD_READERSTATEA, int)>();

  int SCardCancel(
    int hContext,
  ) {
    return _SCardCancel(
      hContext,
    );
  }

  late final _SCardCancelPtr =
      _lookup<ffi.NativeFunction<LONG Function(SCARDCONTEXT)>>('SCardCancel');
  late final _SCardCancel = _SCardCancelPtr.asFunction<int Function(int)>();

  int SCardConnectA(
    int hContext,
    LPCSTR szReader,
    int dwShareMode,
    int dwPreferredProtocols,
    LPSCARDHANDLE phCard,
    LPDWORD pdwActiveProtocol,
  ) {
    return _SCardConnectA(
      hContext,
      szReader,
      dwShareMode,
      dwPreferredProtocols,
      phCard,
      pdwActiveProtocol,
    );
  }

  late final _SCardConnectAPtr = _lookup<
      ffi.NativeFunction<
          LONG Function(SCARDCONTEXT, LPCSTR, DWORD, DWORD, LPSCARDHANDLE,
              LPDWORD)>>('SCardConnectA');
  late final _SCardConnectA = _SCardConnectAPtr.asFunction<
      int Function(int, LPCSTR, int, int, LPSCARDHANDLE, LPDWORD)>();

  int SCardReconnect(
    int hCard,
    int dwShareMode,
    int dwPreferredProtocols,
    int dwInitialization,
    LPDWORD pdwActiveProtocol,
  ) {
    return _SCardReconnect(
      hCard,
      dwShareMode,
      dwPreferredProtocols,
      dwInitialization,
      pdwActiveProtocol,
    );
  }

  late final _SCardReconnectPtr = _lookup<
      ffi.NativeFunction<
          LONG Function(
              SCARDHANDLE, DWORD, DWORD, DWORD, LPDWORD)>>('SCardReconnect');
  late final _SCardReconnect = _SCardReconnectPtr.asFunction<
      int Function(int, int, int, int, LPDWORD)>();

  int SCardDisconnect(
    int hCard,
    int dwDisposition,
  ) {
    return _SCardDisconnect(
      hCard,
      dwDisposition,
    );
  }

  late final _SCardDisconnectPtr =
      _lookup<ffi.NativeFunction<LONG Function(SCARDHANDLE, DWORD)>>(
          'SCardDisconnect');
  late final _SCardDisconnect =
      _SCardDisconnectPtr.asFunction<int Function(int, int)>();

  int SCardBeginTransaction(
    int hCard,
  ) {
    return _SCardBeginTransaction(
      hCard,
    );
  }

  late final _SCardBeginTransactionPtr =
      _lookup<ffi.NativeFunction<LONG Function(SCARDHANDLE)>>(
          'SCardBeginTransaction');
  late final _SCardBeginTransaction =
      _SCardBeginTransactionPtr.asFunction<int Function(int)>();

  int SCardEndTransaction(
    int hCard,
    int dwDisposition,
  ) {
    return _SCardEndTransaction(
      hCard,
      dwDisposition,
    );
  }

  late final _SCardEndTransactionPtr =
      _lookup<ffi.NativeFunction<LONG Function(SCARDHANDLE, DWORD)>>(
          'SCardEndTransaction');
  late final _SCardEndTransaction =
      _SCardEndTransactionPtr.asFunction<int Function(int, int)>();

  int SCardStatusA(
    int hCard,
    LPSTR mszReaderNames,
    LPDWORD pcchReaderLen,
    LPDWORD pdwState,
    LPDWORD pdwProtocol,
    LPBYTE pbAtr,
    LPDWORD pcbAtrLen,
  ) {
    return _SCardStatusA(
      hCard,
      mszReaderNames,
      pcchReaderLen,
      pdwState,
      pdwProtocol,
      pbAtr,
      pcbAtrLen,
    );
  }

  late final _SCardStatusAPtr = _lookup<
      ffi.NativeFunction<
          LONG Function(SCARDHANDLE, LPSTR, LPDWORD, LPDWORD, LPDWORD, LPBYTE,
              LPDWORD)>>('SCardStatusA');
  late final _SCardStatusA = _SCardStatusAPtr.asFunction<
      int Function(int, LPSTR, LPDWORD, LPDWORD, LPDWORD, LPBYTE, LPDWORD)>();

  int SCardTransmit(
    int hCard,
    LPCSCARD_IO_REQUEST pioSendPci,
    LPCBYTE pbSendBuffer,
    int cbSendLength,
    LPSCARD_IO_REQUEST pioRecvPci,
    LPBYTE pbRecvBuffer,
    LPDWORD pcbRecvLength,
  ) {
    return _SCardTransmit(
      hCard,
      pioSendPci,
      pbSendBuffer,
      cbSendLength,
      pioRecvPci,
      pbRecvBuffer,
      pcbRecvLength,
    );
  }

  late final _SCardTransmitPtr = _lookup<
      ffi.NativeFunction<
          LONG Function(SCARDHANDLE, LPCSCARD_IO_REQUEST, LPCBYTE, DWORD,
              LPSCARD_IO_REQUEST, LPBYTE, LPDWORD)>>('SCardTransmit');
  late final _SCardTransmit = _SCardTransmitPtr.asFunction<
      int Function(int, LPCSCARD_IO_REQUEST, LPCBYTE, int, LPSCARD_IO_REQUEST,
          LPBYTE, LPDWORD)>();

  /// /////////////////////////////////////////////////////////////////////////////
  int SCardGetAttrib(
    int hCard,
    int dwAttrId,
    LPBYTE pbAttr,
    LPDWORD pcbAttrLen,
  ) {
    return _SCardGetAttrib(
      hCard,
      dwAttrId,
      pbAttr,
      pcbAttrLen,
    );
  }

  late final _SCardGetAttribPtr = _lookup<
      ffi.NativeFunction<
          LONG Function(
              SCARDHANDLE, DWORD, LPBYTE, LPDWORD)>>('SCardGetAttrib');
  late final _SCardGetAttrib =
      _SCardGetAttribPtr.asFunction<int Function(int, int, LPBYTE, LPDWORD)>();

  int SCardSetAttrib(
    int hCard,
    int dwAttrId,
    LPCBYTE pbAttr,
    int cbAttrLen,
  ) {
    return _SCardSetAttrib(
      hCard,
      dwAttrId,
      pbAttr,
      cbAttrLen,
    );
  }

  late final _SCardSetAttribPtr = _lookup<
      ffi.NativeFunction<
          LONG Function(SCARDHANDLE, DWORD, LPCBYTE, DWORD)>>('SCardSetAttrib');
  late final _SCardSetAttrib =
      _SCardSetAttribPtr.asFunction<int Function(int, int, LPCBYTE, int)>();
}

typedef SCARD_IO_REQUEST = _SCARD_IO_REQUEST;

class _SCARD_IO_REQUEST extends ffi.Struct {
  @DWORD()
  external int dwProtocol;

  @DWORD()
  external int cbPciLength;
}

typedef DWORD = ffi.Uint32;
typedef LONG = ffi.Int64;
typedef LPCVOID = ffi.Pointer<ffi.Void>;
typedef LPSCARDCONTEXT = ffi.Pointer<SCARDCONTEXT>;

/// /////////////////////////////////////////////////////////////////////////////
typedef SCARDCONTEXT = ULONG_PTR;
typedef ULONG_PTR = ffi.Uint64;
typedef LPSTR = ffi.Pointer<CHAR>;
typedef CHAR = ffi.Int8;
typedef LPDWORD = ffi.Pointer<DWORD>;
typedef LPWSTR = ffi.Pointer<WCHAR>;
typedef WCHAR = wchar_t;
typedef wchar_t = ffi.Uint16;
typedef LPCSTR = ffi.Pointer<CHAR>;
typedef LPCWSTR = ffi.Pointer<WCHAR>;
typedef LPCBYTE = ffi.Pointer<BYTE>;
typedef BYTE = ffi.Uint8;
typedef HANDLE = ffi.Pointer<ffi.Void>;

/// /////////////////////////////////////////////////////////////////////////////
class SCARD_READERSTATEA extends ffi.Struct {
  external LPCSTR szReader;

  external LPVOID pvUserData;

  @DWORD()
  external int dwCurrentState;

  @DWORD()
  external int dwEventState;

  @DWORD()
  external int cbAtr;

  @ffi.Array.multi([36])
  external ffi.Array<BYTE> rgbAtr;
}

typedef LPVOID = ffi.Pointer<ffi.Void>;

/// /////////////////////////////////////////////////////////////////////////////
typedef LPSCARD_READERSTATEA = ffi.Pointer<SCARD_READERSTATEA>;

typedef LPSCARDHANDLE = ffi.Pointer<SCARDHANDLE>;
typedef SCARDHANDLE = ULONG_PTR;
typedef LPBYTE = ffi.Pointer<BYTE>;
typedef LPCSCARD_IO_REQUEST = ffi.Pointer<SCARD_IO_REQUEST>;
typedef LPSCARD_IO_REQUEST = ffi.Pointer<_SCARD_IO_REQUEST>;

typedef BOOL = ffi.Int32;
typedef PVOID = ffi.Pointer<ffi.Void>;

typedef PBYTE = ffi.Pointer<BYTE>;
