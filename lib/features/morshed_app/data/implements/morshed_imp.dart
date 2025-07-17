import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/data/sources/morshed_remote_data.dart';
import 'package:tables/features/morshed_app/domain/repositories/morshed_repository.dart';

class MorshedImp extends MorshedRepository {
  final MorshedRemoteData mrd = MorshedRemoteData();

  @override
  Future<MorshedModel> getMorshed(String morshedName, String morshedPassowrd) {
    return mrd.getMorshed(morshedName, morshedPassowrd);
  }
  @override
  Future<List<MorshedModel>> searchMorsheds(String query) {
   return mrd.searchMorsheds(query);
  }

}
