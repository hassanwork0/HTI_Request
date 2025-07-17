
import 'package:tables/features/morshed_app/data/models/morshed_model.dart';

abstract class MorshedRepository{
  
  // Single fetch operations
  Future<MorshedModel> getMorshed(String morshedName , String morshedPassowrd);
  Future<List<MorshedModel>> searchMorsheds(String query); // For search functionality
  

}