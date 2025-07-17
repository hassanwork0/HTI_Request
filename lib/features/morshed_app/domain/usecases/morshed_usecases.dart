import 'package:tables/features/morshed_app/data/models/morshed_model.dart';
import 'package:tables/features/morshed_app/domain/repositories/morshed_repository.dart';

class GetMorshed {
  final MorshedRepository cr;
  const GetMorshed({required this.cr});

  Future<MorshedModel> call(String morshedName, String password) {
    return cr.getMorshed(morshedName, password);
  }
}

class SearchMorsheds {
  final MorshedRepository cr;
  const SearchMorsheds({required this.cr});

  Future<List<MorshedModel>> call(String query) {
    return cr.searchMorsheds(query);
  }
}




