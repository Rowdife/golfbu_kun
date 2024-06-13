class NewScoreCardDataModel {
  final String uploaderName;
  final String uploaderId;
  final String uploadDate;
  final String courseName;
  final int createAtUnix;
  final String weather;
  final int wind;
  final String temperature;

  final List<int> scoreList;
  final List<int> puttsList;
  final List<int> parValueList;

  final int totalScore;
  final int totalPutts;
  final int totalParOn;
  final int totalFairwayFind;
  final int totalFairwayTry;

  final int teeShotMissedLeft;
  final int teeShotMissedRight;
  final int teeShotCriticalMiss;

  final int driverFairwayFind;
  final int driverFairwayTry;
  final int woodFairwayFind;
  final int woodFairwayTry;
  final int utilityFairwayFind;
  final int utilityFairwayTry;
  final int ironFairwayFind;
  final int ironFairwayTry;

  final int parThreeTeeshotTry;
  final int parThreeGreenInRegulation;
  final int parThreeGreenMissedLeft;
  final int parThreeGreenMissedRight;
  final int parThreeGreenMissedShort;
  final int parThreeGreenMissedOver;

  final int totalGreenInRegulation;

  final int greenInRegulationIn50;
  final int greenInRegulationIn50Try;
  final int greenInRegulationIn100;
  final int greenInRegulationIn100Try;
  final int greenInRegulationIn150;
  final int greenInRegulationIn150Try;
  final int greenInRegulationIn200;
  final int greenInRegulationIn200Try;
  final int greenInRegulationOver200;
  final int greenInRegulationOver200Try;

// parOnShot Result
  final int? parOnResultCount;
  final int? parOnShotOnGreen;
  final int? parOnShotMissedLeft;
  final int? parOnShotMissedRight;
  final int? parOnShotMissedShort;
  final int? parOnShotMissedOver;

  //parOnInTotal

  final int parOnByWood;
  final int parOnByWoodTry;
  final int parOnByUtility;
  final int parOnByUtilityTry;
  final int parOnByLongIron;
  final int parOnByLongIronTry;
  final int parOnByMiddleIron;
  final int parOnByMiddleIronTry;
  final int parOnByShortIron;
  final int parOnByShortIronTry;
  final int parOnByWedge;
  final int parOnByWedgeTry;

  final int puttTry;
  final int puttHoleIn;
  final int puttMissedLeft;
  final int puttMissedRight;

  final int puttDistanceTry;
  final int puttDistanceIn1m;
  final int puttDistanceLong;
  final int puttDistanceShort;

  final int puttIn2and5mTry;
  final int puttIn2and5mHoleIn;
  final int puttIn2and5mMissedLeft;
  final int puttIn2and5mMissedRight;

  final int puttIn5mTry;
  final int puttIn5mHoleIn;
  final int puttIn5mMissedLeft;
  final int puttIn5mMissedRight;

  final int puttIn10mTry;
  final int puttIn10mHoleIn;
  final int puttIn10mMissedLeft;
  final int puttIn10mMissedRight;
  final int puttIn10mMissedShort;
  final int puttIn10mMissedLong;
  final int puttIn10mJustTouch;
  final int puttIn10mTwoPutt;

  final int puttInOver10mTry;
  final int puttInOver10mHoleIn;
  final int puttInOver10mMissedLeft;
  final int puttInOver10mMissedRight;
  final int puttInOver10mMissedShort;
  final int puttInOver10mMissedLong;
  final int puttInOver10mJustTouch;
  final int puttInOver10mTwoPutt;

  final int approachTry;
  final int approachParSave;
  final int approachChipIn;

  final int bunkerTry;
  final int bunkerParSave;

  final int birdieChanceCount;
  final int birdieChanceSuccess;

  final int missedGreenInRegulationUnder100;
  final int missedOverThreePutts;
  final int missedIntoBunker;
  final int missedIntoWater;
  final int missedIntoOB;
  final int missedGetPenalty;

  final int overBogeyCount;
  final int bogeyCount;
  final int parCount;
  final int birdieCount;
  final int underBirdieCount;
  final double averagePar3Score;
  final double averagePar4Score;
  final double averagePar5Score;

  NewScoreCardDataModel({
    this.parOnResultCount,
    this.parOnShotOnGreen,
    this.parOnShotMissedLeft,
    this.parOnShotMissedRight,
    this.parOnShotMissedShort,
    this.parOnShotMissedOver,
    required this.uploaderName,
    required this.uploaderId,
    required this.uploadDate,
    required this.courseName,
    required this.createAtUnix,
    required this.weather,
    required this.wind,
    required this.temperature,
    required this.scoreList,
    required this.puttsList,
    required this.parValueList,
    required this.totalScore,
    required this.totalPutts,
    required this.totalFairwayFind,
    required this.totalFairwayTry,
    required this.driverFairwayFind,
    required this.driverFairwayTry,
    required this.woodFairwayFind,
    required this.woodFairwayTry,
    required this.utilityFairwayFind,
    required this.utilityFairwayTry,
    required this.ironFairwayFind,
    required this.ironFairwayTry,
    required this.parThreeTeeshotTry,
    required this.parThreeGreenInRegulation,
    required this.parThreeGreenMissedLeft,
    required this.parThreeGreenMissedRight,
    required this.parThreeGreenMissedShort,
    required this.parThreeGreenMissedOver,
    required this.totalGreenInRegulation,
    required this.greenInRegulationIn50,
    required this.greenInRegulationIn50Try,
    required this.greenInRegulationIn100,
    required this.greenInRegulationIn100Try,
    required this.greenInRegulationIn150,
    required this.greenInRegulationIn150Try,
    required this.greenInRegulationIn200,
    required this.greenInRegulationIn200Try,
    required this.greenInRegulationOver200,
    required this.greenInRegulationOver200Try,
    required this.parOnByWood,
    required this.parOnByWoodTry,
    required this.parOnByUtility,
    required this.parOnByUtilityTry,
    required this.parOnByLongIron,
    required this.parOnByLongIronTry,
    required this.parOnByMiddleIron,
    required this.parOnByMiddleIronTry,
    required this.parOnByShortIron,
    required this.parOnByShortIronTry,
    required this.parOnByWedge,
    required this.parOnByWedgeTry,
    required this.puttTry,
    required this.puttHoleIn,
    required this.puttMissedLeft,
    required this.puttMissedRight,
    required this.puttDistanceTry,
    required this.puttDistanceIn1m,
    required this.puttDistanceLong,
    required this.puttDistanceShort,
    required this.puttIn2and5mTry,
    required this.puttIn2and5mHoleIn,
    required this.puttIn2and5mMissedLeft,
    required this.puttIn2and5mMissedRight,
    required this.puttIn5mTry,
    required this.puttIn5mHoleIn,
    required this.puttIn5mMissedLeft,
    required this.puttIn5mMissedRight,
    required this.puttIn10mTry,
    required this.puttIn10mHoleIn,
    required this.puttIn10mMissedLeft,
    required this.puttIn10mMissedRight,
    required this.puttIn10mMissedShort,
    required this.puttIn10mMissedLong,
    required this.puttIn10mJustTouch,
    required this.puttIn10mTwoPutt,
    required this.puttInOver10mTry,
    required this.puttInOver10mHoleIn,
    required this.puttInOver10mMissedLeft,
    required this.puttInOver10mMissedRight,
    required this.puttInOver10mMissedShort,
    required this.puttInOver10mMissedLong,
    required this.puttInOver10mJustTouch,
    required this.puttInOver10mTwoPutt,
    required this.approachTry,
    required this.approachParSave,
    required this.approachChipIn,
    required this.bunkerTry,
    required this.bunkerParSave,
    required this.birdieChanceCount,
    required this.birdieChanceSuccess,
    required this.missedGreenInRegulationUnder100,
    required this.missedOverThreePutts,
    required this.missedIntoBunker,
    required this.missedIntoWater,
    required this.missedIntoOB,
    required this.missedGetPenalty,
    required this.overBogeyCount,
    required this.bogeyCount,
    required this.parCount,
    required this.birdieCount,
    required this.underBirdieCount,
    required this.averagePar3Score,
    required this.averagePar4Score,
    required this.averagePar5Score,
    required this.totalParOn,
    required this.teeShotMissedLeft,
    required this.teeShotMissedRight,
    required this.teeShotCriticalMiss,
  });

  factory NewScoreCardDataModel.fromJson(Map<String, dynamic> json) {
    return NewScoreCardDataModel(
      uploaderName: json['uploaderName'],
      uploaderId: json['uploaderId'],
      uploadDate: json['uploadDate'],
      courseName: json['courseName'],
      createAtUnix: json['createAtUnix'],
      weather: json['weather'],
      wind: json['wind'],
      temperature: json['temperature'],
      totalScore: json['totalScore'],
      totalPutts: json['totalPutts'],
      totalFairwayFind: json['totalFairwayFind'],
      totalFairwayTry: json['totalFairwayTry'],
      driverFairwayFind: json['driverFairwayFind'],
      driverFairwayTry: json['driverFairwayTry'],
      woodFairwayFind: json['woodFairwayFind'],
      woodFairwayTry: json['woodFairwayTry'],
      utilityFairwayFind: json['utilityFairwayFind'],
      utilityFairwayTry: json['utilityFairwayTry'],
      ironFairwayFind: json['ironFairwayFind'],
      ironFairwayTry: json['ironFairwayTry'],
      parThreeTeeshotTry: json['parThreeTeeshotTry'],
      parThreeGreenInRegulation: json['parThreeGreenInRegulation'],
      parThreeGreenMissedLeft: json['parThreeGreenMissedLeft'],
      parThreeGreenMissedRight: json['parThreeGreenMissedRight'],
      parThreeGreenMissedShort: json['parThreeGreenMissedShort'],
      parThreeGreenMissedOver: json['parThreeGreenMissedOver'],
      totalGreenInRegulation: json['totalGreenInRegulation'],
      greenInRegulationIn50: json['greenInRegulationIn50'],
      greenInRegulationIn50Try: json['greenInRegulationIn50Try'],
      greenInRegulationIn100: json['greenInRegulationIn100'],
      greenInRegulationIn100Try: json['greenInRegulationIn100Try'],
      greenInRegulationIn150: json['greenInRegulationIn150'],
      greenInRegulationIn150Try: json['greenInRegulationIn150Try'],
      greenInRegulationIn200: json['greenInRegulationIn200'],
      greenInRegulationIn200Try: json['greenInRegulationIn200Try'],
      greenInRegulationOver200: json['greenInRegulationOver200'],
      greenInRegulationOver200Try: json['greenInRegulationOver200Try'],
      parOnByWood: json['parOnByWood'],
      parOnByWoodTry: json['parOnByWoodTry'],
      parOnByUtility: json['parOnByUtility'],
      parOnByUtilityTry: json['parOnByUtilityTry'],
      parOnByLongIron: json['parOnByLongIron'],
      parOnByLongIronTry: json['parOnByLongIronTry'],
      parOnByMiddleIron: json['parOnByMiddleIron'],
      parOnByMiddleIronTry: json['parOnByMiddleIronTry'],
      parOnByShortIron: json['parOnByShortIron'],
      parOnByShortIronTry: json['parOnByShortIronTry'],
      parOnByWedge: json['parOnByWedge'],
      parOnByWedgeTry: json['parOnByWedgeTry'],
      puttTry: json['puttTry'],
      puttHoleIn: json['puttHoleIn'],
      puttMissedLeft: json['puttMissedLeft'],
      puttMissedRight: json['puttMissedRight'],
      puttDistanceTry: json['puttDistanceTry'],
      puttDistanceIn1m: json['puttDistanceIn1m'],
      puttDistanceLong: json['puttDistanceLong'],
      puttDistanceShort: json['puttDistanceShort'],
      puttIn2and5mTry: json['puttIn2and5mTry'],
      puttIn2and5mHoleIn: json['puttIn2and5mHoleIn'],
      puttIn2and5mMissedLeft: json['puttIn2and5mMissedLeft'],
      puttIn2and5mMissedRight: json['puttIn2and5mMissedRight'],
      puttIn5mTry: json['puttIn5mTry'],
      puttIn5mHoleIn: json['puttIn5mHoleIn'],
      puttIn5mMissedLeft: json['puttIn5mMissedLeft'],
      puttIn5mMissedRight: json['puttIn5mMissedRight'],
      puttIn10mTry: json['puttIn10mTry'],
      puttIn10mHoleIn: json['puttIn10mHoleIn'],
      puttIn10mMissedLeft: json['puttIn10mMissedLeft'],
      puttIn10mMissedRight: json['puttIn10mMissedRight'],
      puttIn10mMissedShort: json['puttIn10mMissedShort'],
      puttIn10mMissedLong: json['puttIn10mMissedLong'],
      puttIn10mJustTouch: json['puttIn10mJustTouch'],
      puttIn10mTwoPutt: json['puttIn10mTwoPutt'],
      puttInOver10mTry: json['puttInOver10mTry'],
      puttInOver10mHoleIn: json['puttInOver10mHoleIn'],
      puttInOver10mMissedLeft: json['puttInOver10mMissedLeft'],
      puttInOver10mMissedRight: json['puttInOver10mMissedRight'],
      puttInOver10mMissedShort: json['puttInOver10mMissedShort'],
      puttInOver10mMissedLong: json['puttInOver10mMissedLong'],
      puttInOver10mJustTouch: json['puttInOver10mJustTouch'],
      puttInOver10mTwoPutt: json['puttInOver10mTwoPutt'],
      approachTry: json['approachTry'],
      approachParSave: json['approachParSave'],
      approachChipIn: json['approachChipIn'],
      bunkerTry: json['bunkerTry'],
      bunkerParSave: json['bunkerParSave'],
      birdieChanceCount: json['birdieChanceCount'],
      birdieChanceSuccess: json['birdieChanceSuccess'],
      missedGreenInRegulationUnder100: json['missedGreenInRegulationUnder100'],
      missedOverThreePutts: json['missedOverThreePutts'],
      missedIntoBunker: json['missedIntoBunker'],
      missedIntoWater: json['missedIntoWater'],
      missedIntoOB: json['missedIntoOB'],
      missedGetPenalty: json['missedGetPenalty'],
      overBogeyCount: json['overBogeyCount'],
      bogeyCount: json['bogeyCount'],
      parCount: json['parCount'],
      birdieCount: json['birdieCount'],
      underBirdieCount: json['underBirdieCount'],
      averagePar3Score: json['averagePar3Score'],
      averagePar4Score: json['averagePar4Score'],
      averagePar5Score: json['averagePar5Score'],
      scoreList: List<int>.from(json['scoreList']),
      puttsList: List<int>.from(json['puttsList']),
      parValueList: List<int>.from(json['parValueList']),
      totalParOn: json['totalParOn'],
      teeShotMissedLeft: json['teeShotMissedLeft'],
      teeShotMissedRight: json['teeShotMissedRight'],
      teeShotCriticalMiss: json['teeShotCriticalMiss'],
      parOnShotOnGreen: json['parOnShotOnGreen'],
      parOnShotMissedLeft: json['parOnShotMissedLeft'],
      parOnShotMissedRight: json['parOnShotMissedRight'],
      parOnShotMissedShort: json['parOnShotMissedShort'],
      parOnShotMissedOver: json['parOnShotMissedOver'],
      parOnResultCount: json['parOnResultCount'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'uploaderName': uploaderName,
      'uploaderId': uploaderId,
      'uploadDate': uploadDate,
      'courseName': courseName,
      'createAtUnix': createAtUnix,
      'weather': weather,
      'wind': wind,
      'temperature': temperature,
      'totalScore': totalScore,
      'totalPutts': totalPutts,
      'totalFairwayFind': totalFairwayFind,
      'totalFairwayTry': totalFairwayTry,
      'driverFairwayFind': driverFairwayFind,
      'driverFairwayTry': driverFairwayTry,
      'woodFairwayFind': woodFairwayFind,
      'woodFairwayTry': woodFairwayTry,
      'utilityFairwayFind': utilityFairwayFind,
      'utilityFairwayTry': utilityFairwayTry,
      'ironFairwayFind': ironFairwayFind,
      'ironFairwayTry': ironFairwayTry,
      'parThreeTeeshotTry': parThreeTeeshotTry,
      'parThreeGreenInRegulation': parThreeGreenInRegulation,
      'parThreeGreenMissedLeft': parThreeGreenMissedLeft,
      'parThreeGreenMissedRight': parThreeGreenMissedRight,
      'parThreeGreenMissedShort': parThreeGreenMissedShort,
      'parThreeGreenMissedOver': parThreeGreenMissedOver,
      'totalGreenInRegulation': totalGreenInRegulation,
      'greenInRegulationIn50': greenInRegulationIn50,
      'greenInRegulationIn50Try': greenInRegulationIn50Try,
      'greenInRegulationIn100': greenInRegulationIn100,
      'greenInRegulationIn100Try': greenInRegulationIn100Try,
      'greenInRegulationIn150': greenInRegulationIn150,
      'greenInRegulationIn150Try': greenInRegulationIn150Try,
      'greenInRegulationIn200': greenInRegulationIn200,
      'greenInRegulationIn200Try': greenInRegulationIn200Try,
      'greenInRegulationOver200': greenInRegulationOver200,
      'greenInRegulationOver200Try': greenInRegulationOver200Try,
      'parOnByWood': parOnByWood,
      'parOnByWoodTry': parOnByWoodTry,
      'parOnByUtility': parOnByUtility,
      'parOnByUtilityTry': parOnByUtilityTry,
      'parOnByLongIron': parOnByLongIron,
      'parOnByLongIronTry': parOnByLongIronTry,
      'parOnByMiddleIron': parOnByMiddleIron,
      'parOnByMiddleIronTry': parOnByMiddleIronTry,
      'parOnByShortIron': parOnByShortIron,
      'parOnByShortIronTry': parOnByShortIronTry,
      'parOnByWedge': parOnByWedge,
      'parOnByWedgeTry': parOnByWedgeTry,
      "parOnShotMissedLeft": parOnShotMissedLeft,
      "parOnShotMissedRight": parOnShotMissedRight,
      "parOnShotMissedShort": parOnShotMissedShort,
      "parOnShotMissedOver": parOnShotMissedOver,
      'puttTry': puttTry,
      'puttHoleIn': puttHoleIn,
      'puttMissedLeft': puttMissedLeft,
      'puttMissedRight': puttMissedRight,
      'puttDistanceTry': puttDistanceTry,
      'puttDistanceIn1m': puttDistanceIn1m,
      'puttDistanceLong': puttDistanceLong,
      'puttDistanceShort': puttDistanceShort,
      'puttIn2and5mTry': puttIn2and5mTry,
      'puttIn2and5mHoleIn': puttIn2and5mHoleIn,
      'puttIn2and5mMissedLeft': puttIn2and5mMissedLeft,
      'puttIn2and5mMissedRight': puttIn2and5mMissedRight,
      'puttIn5mTry': puttIn5mTry,
      'puttIn5mHoleIn': puttIn5mHoleIn,
      'puttIn5mMissedLeft': puttIn5mMissedLeft,
      'puttIn5mMissedRight': puttIn5mMissedRight,
      'puttIn10mTry': puttIn10mTry,
      'puttIn10mHoleIn': puttIn10mHoleIn,
      'puttIn10mMissedLeft': puttIn10mMissedLeft,
      'puttIn10mMissedRight': puttIn10mMissedRight,
      'puttIn10mMissedShort': puttIn10mMissedShort,
      'puttIn10mMissedLong': puttIn10mMissedLong,
      'puttIn10mJustTouch': puttIn10mJustTouch,
      'puttIn10mTwoPutt': puttIn10mTwoPutt,
      'puttInOver10mTry': puttInOver10mTry,
      'puttInOver10mHoleIn': puttInOver10mHoleIn,
      'puttInOver10mMissedLeft': puttInOver10mMissedLeft,
      'puttInOver10mMissedRight': puttInOver10mMissedRight,
      'puttInOver10mMissedShort': puttInOver10mMissedShort,
      'puttInOver10mMissedLong': puttInOver10mMissedLong,
      'puttInOver10mJustTouch': puttInOver10mJustTouch,
      'puttInOver10mTwoPutt': puttInOver10mTwoPutt,
      'approachTry': approachTry,
      'approachParSave': approachParSave,
      'approachChipIn': approachChipIn,
      'bunkerTry': bunkerTry,
      'bunkerParSave': bunkerParSave,
      'birdieChanceCount': birdieChanceCount,
      'birdieChanceSuccess': birdieChanceSuccess,
      'missedGreenInRegulationUnder100': missedGreenInRegulationUnder100,
      'missedOverThreePutts': missedOverThreePutts,
      'missedIntoBunker': missedIntoBunker,
      'missedIntoWater': missedIntoWater,
      'missedIntoOB': missedIntoOB,
      'missedGetPenalty': missedGetPenalty,
      'overBogeyCount': overBogeyCount,
      'bogeyCount': bogeyCount,
      'parCount': parCount,
      'birdieCount': birdieCount,
      'underBirdieCount': underBirdieCount,
      'averagePar3Score': averagePar3Score,
      'averagePar4Score': averagePar4Score,
      'averagePar5Score': averagePar5Score,
      'scoreList': scoreList,
      'puttsList': puttsList,
      'parValueList': parValueList,
      'teeShotMissedLeft': teeShotMissedLeft,
      'teeShotMissedRight': teeShotMissedRight,
      'teeShotCriticalMiss': teeShotCriticalMiss,
      'totalParOn': totalParOn,
    };
  }

  static NewScoreCardDataModel empty() {
    return NewScoreCardDataModel(
      uploaderName: '',
      uploaderId: '',
      uploadDate: '',
      courseName: '',
      createAtUnix: 0,
      weather: '',
      wind: 0,
      temperature: "",
      totalScore: 0,
      totalPutts: 0,
      totalFairwayFind: 0,
      totalFairwayTry: 0,
      driverFairwayFind: 0,
      driverFairwayTry: 0,
      woodFairwayFind: 0,
      woodFairwayTry: 0,
      utilityFairwayFind: 0,
      utilityFairwayTry: 0,
      ironFairwayFind: 0,
      ironFairwayTry: 0,
      parThreeTeeshotTry: 0,
      parThreeGreenInRegulation: 0,
      parThreeGreenMissedLeft: 0,
      parThreeGreenMissedRight: 0,
      parThreeGreenMissedShort: 0,
      parThreeGreenMissedOver: 0,
      totalGreenInRegulation: 0,
      greenInRegulationIn50: 0,
      greenInRegulationIn50Try: 0,
      greenInRegulationIn100: 0,
      greenInRegulationIn100Try: 0,
      greenInRegulationIn150: 0,
      greenInRegulationIn150Try: 0,
      greenInRegulationIn200: 0,
      greenInRegulationIn200Try: 0,
      greenInRegulationOver200: 0,
      greenInRegulationOver200Try: 0,
      parOnByWood: 0,
      parOnByWoodTry: 0,
      parOnByUtility: 0,
      parOnByUtilityTry: 0,
      parOnByLongIron: 0,
      parOnByLongIronTry: 0,
      parOnByMiddleIron: 0,
      parOnByMiddleIronTry: 0,
      parOnByShortIron: 0,
      parOnByShortIronTry: 0,
      parOnByWedge: 0,
      parOnByWedgeTry: 0,
      puttTry: 0,
      puttHoleIn: 0,
      puttMissedLeft: 0,
      puttMissedRight: 0,
      puttDistanceTry: 0,
      puttDistanceIn1m: 0,
      puttDistanceLong: 0,
      puttDistanceShort: 0,
      puttIn2and5mTry: 0,
      puttIn2and5mHoleIn: 0,
      puttIn2and5mMissedLeft: 0,
      puttIn2and5mMissedRight: 0,
      puttIn5mTry: 0,
      puttIn5mHoleIn: 0,
      puttIn5mMissedLeft: 0,
      puttIn5mMissedRight: 0,
      puttIn10mTry: 0,
      puttIn10mHoleIn: 0,
      puttIn10mMissedLeft: 0,
      puttIn10mMissedRight: 0,
      puttIn10mMissedShort: 0,
      puttIn10mMissedLong: 0,
      puttIn10mJustTouch: 0,
      puttIn10mTwoPutt: 0,
      puttInOver10mTry: 0,
      puttInOver10mHoleIn: 0,
      puttInOver10mMissedLeft: 0,
      puttInOver10mMissedRight: 0,
      puttInOver10mMissedShort: 0,
      puttInOver10mMissedLong: 0,
      puttInOver10mJustTouch: 0,
      puttInOver10mTwoPutt: 0,
      approachTry: 0,
      approachParSave: 0,
      approachChipIn: 0,
      bunkerTry: 0,
      bunkerParSave: 0,
      birdieChanceCount: 0,
      birdieChanceSuccess: 0,
      missedGreenInRegulationUnder100: 0,
      missedOverThreePutts: 0,
      missedIntoBunker: 0,
      missedIntoWater: 0,
      missedIntoOB: 0,
      missedGetPenalty: 0,
      overBogeyCount: 0,
      bogeyCount: 0,
      parCount: 0,
      birdieCount: 0,
      underBirdieCount: 0,
      averagePar3Score: 0,
      averagePar4Score: 0,
      averagePar5Score: 0,
      scoreList: [],
      puttsList: [],
      parValueList: [],
      teeShotMissedLeft: 0,
      teeShotMissedRight: 0,
      teeShotCriticalMiss: 0,
      totalParOn: 0,
      parOnShotOnGreen: null,
      parOnShotMissedLeft: null,
      parOnShotMissedRight: null,
      parOnShotMissedShort: null,
      parOnShotMissedOver: null,
      parOnResultCount: null,
    );
  }
}
