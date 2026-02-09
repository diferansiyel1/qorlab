import 'pubchem_api_client_contract.dart';
import 'pubchem_api_client_stub.dart'
    if (dart.library.io) 'pubchem_api_client_io.dart' as impl;

PubChemApiClient createPubChemApiClient() => impl.createPubChemApiClient();
