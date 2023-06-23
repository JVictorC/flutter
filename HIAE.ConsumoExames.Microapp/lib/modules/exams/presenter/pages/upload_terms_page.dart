import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/extensions/translate_extension.dart';
import '../../../../core/widgets/bread_crumbs.dart';
import '../../../../core/widgets/default_app_bar.dart';

class UploadTermsPage extends StatefulWidget {
  const UploadTermsPage({Key? key}) : super(key: key);

  @override
  State<UploadTermsPage> createState() => _UploadTermsPageState();
}

class _UploadTermsPageState extends State<UploadTermsPage> {
  bool _showMyExamsStep = true;
  bool _loadedData = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_loadedData) {
      _showMyExamsStep = ModalRoute.of(context)?.settings.arguments != false;
      _loadedData = true;
    }
  }

  @override
  Widget build(BuildContext context) => ZeraScaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kIsWeb)
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                    ),
                    child: BreadCrumbs(
                      listBreadCrumbs: _showMyExamsStep
                          ? [
                              RESULTS_OF_EXAMS,
                              EXAMS_EINSTEIN,
                              IMPORT_EXAMS,
                              TERMS_OF_USE,
                            ]
                          : [
                              RESULTS_OF_EXAMS,
                              IMPORT_EXAMS,
                              TERMS_OF_USE,
                            ],
                    ),
                  ),
                ),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  width: MediaQuery.of(context).size.width,
                  height: kNavBarHeight + 20,
                  child: const DefaultAppBar(
                    leftPaddingHeader: 0,
                    hasMaxWidth: true,
                  ),
                ),
              ),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ZeraText(
                    TERMS_USE.translate(),
                    type: ZeraTextType.BOLD_24_NEUTRAL_DARK_BASE,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ZeraText(
                        '''
A Sociedade Beneficente Israelita Brasileira Hospital Albert Einstein, está disponibilizando no portal do paciente (Meu Einstein) acesso on line as suas informações médicas e de seus dependentes que estejam armazenadas na Instituição, tais como, resultados de exames, passagens em pronto atendimento, internações, prontuários entre outras.

O acesso a esses conteúdos multimídia será realizado via página Web www.einstein.br em uma área logada “Meu Einstein”) ou Aplicativo “Meu Einstein”, de forma que o paciente acompanhe as suas informações médicas e de seus dependentes que estejam armazenadas na Instituição.

O cadastro para o uso do portal do paciente “Meu Einstein” será realizado no primeiro acesso do usuário e, será permitido um único cadastramento por usuário, devendo o acesso, a visualização e o uso do portal do paciente “Meu Einstein” ser feito pelo usuário em caráter pessoal e intransferível.

No caso de usuários menores de 18 anos ou de outras pessoas que necessitem de representação na forma da lei, o cadastramento deverá ser realizado com a assistência dos pais ou dos representantes legais.
Toda e qualquer ação executada ou conteúdo publicado pelo usuário durante o uso do portal do paciente “Meu Einstein” será de sua exclusiva e integral responsabilidade, devendo isentar e indenizar a Sociedade Beneficente Israelita Brasileira Hospital Albert Einstein de quaisquer reclamações, prejuízos, perdas e danos causados à SOCIEDADE BENEFICENTE ISRAELITA BRASILEIRA HOSPITAL ALBERT EINSTEIN, em decorrência de tais ações ou manifestações.

A SOCIEDADE BENEFICENTE ISRAELITA BRASILEIRA HOSPITAL ALBERT EINSTEIN se reserva o direito de incluir, excluir ou alterar os conteúdos e funcionalidades do portal do paciente ”Meu Einstein”, bem como suspendê-lo temporariamente ou cancelá-lo, a qualquer momento, independentemente de aviso-prévio ao usuário. Da mesma forma, poderá modificar o presente “Termos de Uso e Política de Privacidade”, cuja versão mais recente estará sempre disponível para consulta através do próprio portal do paciente “Meu Einstein”.

A SOCIEDADE BENEFICENTE ISRAELITA BRASILEIRA HOSPITAL ALBERT EINSTEIN não se responsabiliza por qualquer dano, prejuízo ou perda no equipamento do usuário causado por falhas no sistema no portal do paciente “Meu Einstein” na Internet. A SOCIEDADE BENEFICENTE ISRAELITA BRASILEIRA HOSPITAL ALBERT EINSTEIN também não será responsável por qualquer vírus que possa atacar o equipamento do usuário em decorrência do acesso, utilização ou navegação no aplicativo e na Internet; ou como conseqüência da transferência de dados, arquivos, imagens, textos ou áudio. O usuário não poderá atribuir à SOCIEDADE BENEFICENTE ISRAELITA BRASILEIRA HOSPITAL ALBERT EINSTEIN nenhuma responsabilidade nem exigir o pagamento por lucro cessante em virtude de prejuízos resultantes de dificuldades técnicas, falhas no aplicativo ou na Internet e perda de dados ou mídias.
Os conteúdos multimídia compartilhados nas redes sociais não terão o controle de privacidade do portal do paciente “Meu Einstein”. Ou seja, esses conteúdos multimídia não estarão sob vigência do presente “Termo de Uso e Política de Privacidade”, passando a estar sob a vigência dos Termos de Uso e Política de Privacidade das respectivas redes sociais.

A SOCIEDADE BENEFICENTE ISRAELITA BRASILEIRA HOSPITAL ALBERT EINSTEIN SE EXIME DE TODA E QUALQUER RESPONSABILIDADE PELOS DANOS E PREJUÍZOS DE QUALQUER NATUREZA QUE POSSAM DECORRER DO ACESSO, INTERCEPTAÇÃO, ELIMINAÇÃO, ALTERAÇÃO, MODIFICAÇÃO OU MANIPULAÇÃO, POR TERCEIROS NÃO AUTORIZADOS, DOS DADOS DO USUÁRIO DURANTE A UTILIZAÇÃO DO PORTAL DO PACIENTE “MEU EINSTEIN”.

As informações solicitadas ao usuário no momento do cadastro serão utilizadas pela SOCIEDADE BENEFICENTE ISRAELITA BRASILEIRA HOSPITAL ALBERT EINSTEIN somente para os fins previstos no presente “Termos de Uso e Política de Privacidade” e em nenhuma circunstância, tais informações serão cedidas ou compartilhadas com terceiros, exceto por ordem judicial ou de autoridade competente.
As informações são processadas nas instalações operacionais da SOCIEDADE BENEFICENTE ISRAELITA BRASILEIRA HOSPITAL ALBERT EINSTEIN e em qualquer outro lugar onde as partes envolvidas com o processamento estejam localizadas. Para mais informações, contate o fornecedor da Aplicação.

As informações serão mantidas pelo tempo necessário para fornecer o serviço solicitado pelo Usuário, ou declarado pelos propósitos descritos neste documento, e o Usuário sempre pode solicitar que o fornecedor da Aplicação suspenda ou remova os dados.

A câmera (uso de android.permission.CAMERA) é usada se o usuário desejar:

• Carregar foto / vídeo para fornecer conteúdo para o aplicativo

• Atualizar a imagem de perfil

O gravador de áudio (uso de 
android.permission.RECORD_AUDIO) é usada se o usuário desejar:

• Carregar áudio para fornecer conteúdo para o aplicativo

Acesso somente leitura ao estado do telefone (uso de android.permission.READ_PHONE_STATE):

• Permite acesso somente leitura ao estado do telefone, incluindo o número de telefone do dispositivo, as informações atuais sobre a rede.
Para fins de operação e manutenção, esta Aplicação e quaisquer serviços de terceiros podem coletar arquivos que registram interação com esta Aplicação (Logs do Sistema) ou usam outros Dados Pessoais (tais como Endereço IP).

Mais detalhes sobre a coleta ou processamento de Dados Pessoais podem ser solicitados ao fornecedor da Aplicação a qualquer momento. Consulte as informações de contato no início deste documento.
O fornecedor da Aplicação se reserva o direito de fazer alterações a esta política de privacidade a qualquer momento, dando aviso aos seus Usuários nesta página. É altamente recomendável verificar esta página frequentemente, referindo-se à data da última modificação listada na parte inferior. Se um Usuário se opuser a qualquer das alterações à Política, o Usuário deverá cessar de usar esta Aplicação e poderá solicitar que o fornecedor da Aplicação apague os Dados Pessoais. Salvo indicação em contrário, a política de privacidade vigente aplica-se a todos os Dados Pessoais que o fornecedor da Aplicação tem sobre os Usuários.

A SOCIEDADE BENEFICENTE ISRAELITA BRASILEIRA HOSPITAL ALBERT EINSTEIN não cobrará por esse serviço, sendo o mesmo gratuito.
A SOCIEDADE BENEFICENTE ISRAELITA BRASILEIRA HOSPITAL ALBERT EINSTEIN não compartilha informações pessoas de seus pacientes com terceiros. Estas informações são acessadas apenas pela equipe médica e assistencial da Instituição.

Ao concordar, o usuário submeter-se-á automaticamente aos termos e condições estabelecidos pelo presente “Termos de Uso e Política de Privacidade” do portal do paciente “Meu Einstein”.
                    ''',
                        color: ZeraColors.neutralDark01,
                        theme: const ZeraTextTheme(
                          fontSize: 16,
                          lineHeight: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
