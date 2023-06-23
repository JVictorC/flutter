import 'package:contatos_vo/src/main.dart';
import 'package:contatos_vo/src/presentation/viewModels/home_page_view_model/view_model.dart';

initCubitDependencies() {
  I.registesDependency<HomePageCubit>(
    HomePageCubit(
      getAllContactsUseCases: I.get<IGetAllContactsUseCases>(),
    ),
  );
}
