import 'package:scoped_model/scoped_model.dart';
import './Connected_db.dart';

class MainModel extends Model
    with
        Connected_dbModel,
        UserModel,
        UserRegisterModel,
        ProductsModel,
        UtilityModel,
        CategoriesModel {}
