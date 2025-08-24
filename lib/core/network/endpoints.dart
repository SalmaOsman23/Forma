class EndPoints {
  // Main API base URL
  static const String baseURL = "https://exercisedb.p.rapidapi.com";
  
  // Exercise API endpoints
  static const String exercises = "/exercises";
  static const String exerciseById = "/exercises/exercise";
  static const String exerciseByName = "/exercises/name";
  static const String exerciseByTarget = "/exercises/target";
  static const String exerciseByEquipment = "/exercises/equipment";
  static const String exerciseByBodyPart = "/exercises/bodyPart";
  static const String targetList = "/exercises/targetList";
  static const String equipmentList = "/exercises/equipmentList";
  static const String bodyPartList = "/exercises/bodyPartList";
  
  // API configuration
  static const String apiKey = "d331079442msh45c46abe4f62830p17a4cdjsn756d3c83bc36";
  static const String apiHost = "exercisedb.p.rapidapi.com";
}