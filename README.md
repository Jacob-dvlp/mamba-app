# 🔥 Mamba Fast Tracker

> Aplicativo de controle de jejum intermitente + registro de calorias
> Desenvolvido como solução para o Desafio Técnico – Mamba Growth | Mobile Apps Division

---

## 📱 Como rodar o projeto

### Pré-requisitos
- Flutter SDK `>=3.3.0`
- Android SDK / Emulador ou dispositivo físico Android
- Conta Firebase (para Auth)

### 1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/mamba_fast_tracker.git
cd mamba_fast_tracker
```

### 2. Instale as dependências
```bash
flutter pub get
```

### 3. Configure o Firebase

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com)
2. Ative **Authentication → Email/Senha**
3. Adicione o app Android (package: `com.mamba.fast_tracker`)
4. Baixe o `google-services.json` e coloque em `android/app/`

> O app usa `firebase_core` e `firebase_auth`. Não há Firestore — todos os dados ficam locais (Hive).

### 4. Rode o app
```bash
flutter run
```

### 5. Gerar APK release
```bash
flutter build apk --release
# APK em: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🛠 Stack escolhida

| Camada | Tecnologia |
|--------|-----------|
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

---

## 🏗 Arquitetura utilizada

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
```

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

---

## 📦 Bibliotecas utilizadas

| Lib | Versão | Motivo |
|-----|--------|--------|
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

**Não utilizadas propositalmente:** `freezed`, `json_serializable`, `hive_generator` — causavam conflitos de build e foram substituídas por código manual simples e sem dependências de geração.

---

## ⚖️ Trade-offs considerados

| Decisão | Trade-off |
|---------|-----------|
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
- **Firebase Analytics + Crashlytics** para monitoramento em produção
- **Feature Flags** via Firebase Remote Config
- **Widget de onboarding** para novos usuários

---

## ⏱ Tempo gasto

| Dia | Atividade | Tempo |
|-----|-----------|-------|
| 1 | Setup, Firebase, GetIt, GoRouter, Auth completa | ~6h |
| 2 | Domain layer, Data layer, Hive adapters, FastCubit | ~7h |
| 3 | Screens (Home timer, Meals, History, Stats) | ~6h |
| 4 | Polish, README, build APK | ~3h |
| **Total** | | **~22h** |

---

## 📲 APK

O APK release está disponível em `/releases` no repositório ou pode ser gerado com:

```bash
flutter build apk --release
```