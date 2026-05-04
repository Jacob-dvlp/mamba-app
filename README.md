# 🔥 Mamba Fast Tracker

> Aplicativo de controle de jejum intermitente + registro de calorias
> Desenvolvido como solução para o Desafio Técnico – Mamba Growth | Mobile Apps Division

📺 [Vídeo de apresentação](https://youtu.be/q8vPhekVPSs) &nbsp;|&nbsp; 📲 [Play Store](https://play.google.com/store/apps/details?id=com.mamba.mamba_fast_tracker)

---

## 📋 Índice

- [Pré-requisitos](#-pré-requisitos)
- [Instalação passo a passo](#-instalação-passo-a-passo)
- [Configuração do Firebase](#-configuração-do-firebase)
- [Rodando o app](#-rodando-o-app)
- [Gerar APK](#-gerar-apk-release)
- [Solução de problemas](#-solução-de-problemas)
- [Arquitetura](#-arquitetura)
- [Stack](#-stack)
- [Decisões técnicas](#️-decisões-técnicas)
- [Trade-offs](#️-trade-offs-considerados)
- [Melhorias futuras](#-o-que-melhoraria-com-mais-tempo)
- [Tempo gasto](#-tempo-gasto)

---

## ✅ Pré-requisitos

Antes de começar, verifique se você tem tudo instalado:

| Ferramenta | Versão mínima | Verificar com |
|---|---|---|
| Flutter SDK | `>= 3.3.0` | `flutter --version` |
| Dart SDK | incluído no Flutter | `dart --version` |
| Android SDK | API 21+ | Android Studio → SDK Manager |
| Java JDK | 17+ | `java -version` |
| Git | qualquer | `git --version` |

> **Dica:** Rode `flutter doctor` para um diagnóstico completo do ambiente.

```bash
flutter doctor -v
```

Todos os itens devem estar marcados com ✅. Resolva qualquer ❌ antes de continuar.

---

## 🚀 Instalação passo a passo

### 1. Clone o repositório

```bash
git clone https://github.com/Jacob-dvlp/mamba-app.git
cd mamba-app
```

### 2. Instale as dependências

```bash
flutter pub get
```

> Se houver erros de dependência, tente:
> ```bash
> flutter clean && flutter pub get
> ```

### 3. Configure o Firebase (obrigatório)

> O app usa **Firebase Authentication**. Sem essa configuração, o login não funcionará.

#### Opção A — Usando o arquivo já configurado (recomendado para avaliadores)

O arquivo `google-services.json` já está incluído no repositório em `android/app/google-services.json`. Nenhuma ação adicional é necessária.

#### Opção B — Configurando seu próprio projeto Firebase

1. Acesse o [Firebase Console](https://console.firebase.google.com/) e crie um projeto
2. Adicione um app Android com o package name: `com.mamba.mamba_fast_tracker`
3. Baixe o arquivo `google-services.json` gerado
4. Substitua o arquivo em: `android/app/google-services.json`
5. No console do Firebase, habilite **Authentication → Sign-in method → Email/Password**

---

## ▶️ Rodando o app

### Em emulador Android

```bash
# Liste os dispositivos disponíveis
flutter devices

# Rode o app (Flutter escolhe automaticamente o dispositivo disponível)
flutter run
```

### Em dispositivo físico Android

1. Ative o **Modo Desenvolvedor** no celular:
   - Vá em *Configurações → Sobre o telefone → Número da versão* e toque 7 vezes
2. Ative a **Depuração USB** nas opções do desenvolvedor
3. Conecte o celular via USB e aceite a permissão de depuração
4. Verifique se o dispositivo é reconhecido:
   ```bash
   flutter devices
   ```
5. Rode o app:
   ```bash
   flutter run
   ```

### Em modo release (performance real)

```bash
flutter run --release
```

---

## 📦 Gerar APK release

```bash
flutter build apk --release
```

O APK gerado estará em:
```
build/app/outputs/flutter-apk/app-release.apk
```

Para instalar diretamente no dispositivo conectado:
```bash
flutter install
```

---

## 🔧 Solução de problemas

### `flutter pub get` falha com erros de versão

```bash
flutter upgrade
flutter pub get
```

### Erro `google-services.json not found`

Verifique se o arquivo existe no caminho correto:
```
android/
└── app/
    └── google-services.json  ← deve estar aqui
```

### Erro de Gradle na build

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Emulador não aparece em `flutter devices`

- Abra o Android Studio → Device Manager → inicie um emulador
- Ou crie um novo emulador com API 21+

### Hive: erro de TypeAdapter ao reabrir o app

Isso pode ocorrer se o app tiver dados corrompidos de uma versão anterior. Limpe os dados do app no dispositivo e reinicie.

### Notificações não aparecem

Em Android 13+, o app precisa de permissão explícita para notificações. Verifique em *Configurações → Apps → Mamba Fast Tracker → Notificações*.

---

## 🏗 Arquitetura

**Clean Architecture** em 3 camadas:

```
lib/
├── core/               # DI (GetIt), Router (GoRouter), Theme
├── domain/             # Entities, Use Cases, Repository Interfaces
│   ├── entities/       # FastSession, Meal, DailyLog, FastProtocol, UserProfile
│   ├── usecases/       # StartFast, AddMeal, GetDailyLog...
│   └── repositories/   # Interfaces abstratas (IFastRepository, IAuthRepository...)
├── data/               # Implementações concretas
│   ├── models/         # DTOs com TypeAdapters manuais para Hive
│   └── repositories/   # HiveFastRepo, HiveMealRepo, FirebaseAuthRepo
├── presentation/       # Screens + Cubits por feature
│   ├── auth/           # Login, Register + AuthCubit
│   ├── home/           # Timer principal + FastCubit
│   ├── meals/          # Refeições + MealCubit
│   ├── history/        # Histórico 30 dias + HistoryCubit
│   └── stats/          # Gráficos semanais + StatsCubit
└── services/           # NotificationService
└── teste/              # Testes unitários
```

---

## 🛠 Stack

| Camada | Tecnologia |
|---|---|
| Linguagem | Dart / Flutter |
| Estado | `flutter_bloc` — Cubit pattern |
| Navegação | `go_router` com auth guard |
| DI | `get_it` |
| Persistência local | `hive` + `hive_flutter` |
| Autenticação | Firebase Auth (`firebase_auth`) |
| Notificações | `flutter_local_notifications` |
| Gráficos | `fl_chart` |
| Igualdade de entidades | `equatable` |
| IDs únicos | `uuid` |
| Deploy OTA | Shorebird (Play Store) |

### Bibliotecas principais

| Lib | Versão | Motivo |
|---|---|---|
| `flutter_bloc` | ^8.1.6 | State management com Cubit |
| `get_it` | ^8.0.2 | Service locator / DI |
| `go_router` | ^14.2.0 | Navegação declarativa com guards |
| `hive` + `hive_flutter` | ^2.2.3 / ^1.1.0 | Persistência local rápida e offline-first |
| `firebase_core` + `firebase_auth` | ^3.3 / ^5.1 | Autenticação robusta |
| `flutter_local_notifications` | ^17.2.2 | Notificações locais agendadas |
| `fl_chart` | ^0.68.0 | Gráficos de barras semanais |
| `equatable` | ^2.0.5 | `==` e `hashCode` sem boilerplate |
| `uuid` | ^4.4.0 | IDs únicos para entidades |
| `intl` | ^0.19.0 | Formatação de datas em pt_BR |

> **Não utilizadas propositalmente:** `freezed`, `json_serializable`, `hive_generator` — causavam conflitos de build e foram substituídas por código manual simples e sem dependências de geração.

---

## ⚙️ Decisões técnicas

### Timer — core feature

O timer foi implementado para ser resiliente ao fechamento do app:

1. Ao **iniciar** o jejum, `startTime` é persistido imediatamente no Hive
2. O `FastCubit` mantém um `Timer.periodic(1s)` enquanto o app está em foreground
3. Ao **fechar e reabrir** o app, o `FastCubit` chama `GetActiveSessionUseCase` no construtor e restaura o estado calculando `elapsed = DateTime.now() - startTime - pausedDuration`
4. **Pause/Resume** acumulam o tempo pausado em `pausedDuration` — nunca perdem progresso
5. Notificação **agendada** via `zonedSchedule` para disparar quando o jejum terminar, mesmo com o app fechado

### Hive sem code generation

Optei por escrever `TypeAdapter` manualmente para evitar conflitos de `hive_generator`, `freezed` e `json_serializable`. Os adapters são simples e leem/escrevem campos posicionais com `BinaryReader/Writer` — totalmente controlado, zero magia.

### Firebase Auth com interface

`FirebaseAuthRepository` implementa `IAuthRepository`. Para futuramente migrar para uma API REST, basta criar `RestAuthRepository` com a mesma interface e trocar o registro no `GetIt` — **zero mudanças** no domain e presentation.

### GoRouter + Auth Guard

O router usa `redirect` + `refreshListenable` conectado ao stream do `AuthCubit`. Qualquer mudança de estado de autenticação aciona automaticamente o redirect correto.

### Cubit vs Bloc

Usei **Cubit** (sem `on<Event>`) pois os estados das features são simples e diretos. Cubit reduz boilerplate sem perder testabilidade — métodos públicos são fáceis de mockar em testes unitários.

### Shorebird (Code Push)

Integrado para permitir atualizações de código em produção sem reinstalar o app pela Play Store. Aplica patches incrementais no Flutter, reduzindo drasticamente o tempo de resposta para correções críticas.

---

## ⚖️ Trade-offs considerados

| Decisão | Trade-off |
|---|---|
| Hive sem code gen | Adapters manuais são mais verbose, mas sem conflito algum |
| Firebase Auth apenas | Sem Firestore = sem sincronização entre dispositivos. Aceitável para MVP |
| Timer via `Timer.periodic` | Simples e confiável em foreground; background depende de notificação agendada |
| Clean Architecture | Mais arquivos, mais indireção — compensa em escalabilidade e testabilidade |
| Cubit sem Events | Menos boilerplate, suficiente para a complexidade atual |

---

## 🚀 O que melhoraria com mais tempo

- **Testes unitários** para todos os UseCases e Cubits
- **Firestore** para sincronização entre dispositivos com merge offline-first
- **CI/CD** com GitHub Actions: lint + testes + build APK automático
- **Feature Flags** via Firebase Remote Config
- **Widget de onboarding** para novos usuários

---

## ⏱ Tempo gasto

| Dia | Atividade | Tempo |
|---|---|---|
| 1 | Setup, Firebase, GetIt, GoRouter, Auth completa | ~6h |
| 2 | Domain layer, Data layer, Hive adapters, FastCubit | ~7h |
| 3 | Screens (Home timer, Meals, History, Stats) | ~6h |
| 4 | Polish, README, build APK | ~3h |
| **Total** | | **~22h** |
