class PubChemCompound {
  final int cid;
  final String query;
  final String? title;
  final String? molecularFormula;
  final String? molecularWeight;
  final String? iupacName;
  final String? canonicalSmiles;
  final String? inchiKey;
  final String? xlogp;
  final String? tpsa;
  final int? hBondDonorCount;
  final int? hBondAcceptorCount;
  final int? rotatableBondCount;
  final int? complexity;
  final int? charge;
  final String? exactMass;
  final String? monoisotopicMass;
  final int? heavyAtomCount;
  final int? isotopeAtomCount;
  final int? atomStereoCount;
  final int? definedAtomStereoCount;
  final int? undefinedAtomStereoCount;
  final int? bondStereoCount;
  final int? definedBondStereoCount;
  final int? undefinedBondStereoCount;
  final int? covalentUnitCount;
  final List<String> synonyms;
  final DateTime fetchedAt;

  const PubChemCompound({
    required this.cid,
    required this.query,
    required this.title,
    required this.molecularFormula,
    required this.molecularWeight,
    required this.iupacName,
    required this.canonicalSmiles,
    required this.inchiKey,
    required this.xlogp,
    required this.tpsa,
    required this.hBondDonorCount,
    required this.hBondAcceptorCount,
    required this.rotatableBondCount,
    required this.complexity,
    required this.charge,
    required this.exactMass,
    required this.monoisotopicMass,
    required this.heavyAtomCount,
    required this.isotopeAtomCount,
    required this.atomStereoCount,
    required this.definedAtomStereoCount,
    required this.undefinedAtomStereoCount,
    required this.bondStereoCount,
    required this.definedBondStereoCount,
    required this.undefinedBondStereoCount,
    required this.covalentUnitCount,
    required this.synonyms,
    required this.fetchedAt,
  });

  String get displayName =>
      (title?.trim().isNotEmpty ?? false) ? title! : query;

  String get structurePngUrl => structure2dPngUrl;

  String get structure2dPngUrl =>
      'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/$cid/PNG?record_type=2d&image_size=large';

  String get structure3dPngUrl =>
      'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/$cid/PNG?record_type=3d&image_size=large';
}
