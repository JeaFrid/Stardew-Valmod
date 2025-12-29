# Stardew Valmod!

![Valmod](https://raw.githubusercontent.com/JeaFrid/Stardew-Valmod/refs/heads/main/assets/github/valmod_1.png)

Valmod, Stardew Valley için açık kaynak kodlu bir mod yöneticisidir. [NexusMod](https://www.nexusmods.com/) sitesi içeriğinde yer alan modları indirmek, indirilen modları yönetmek, klasörler ve mod paketleri oluşturmak için Valmod, muhteşem bir seçenektir!
-----
![Valmod İndir ve Kur](https://raw.githubusercontent.com/JeaFrid/Stardew-Valmod/refs/heads/main/assets/github/valmod_2.png)

Valmod, kurulabilir bir sürüme sahiptir. Valmod'u paketlemek için Inno Setup kullanılmıştır.

> [!IMPORTANT]
> ## Windows 10 / 11
> İndirilebilir sürüm mevcut. 
> Windows sürümü Webview2 desteği içerdiğinden bilgisayarınızda Edge motoru olduğundan emin olun.
> [![İndir](https://img.shields.io/badge/İndir-Windows%2010%20%2F%2011-blue?style=for-the-badge&logo=windows)](https://github.com/JeaFrid/Stardew-Valmod/releases/latest)

> [!WARNING]
> ## Linux
> Çok yakında Linux (Steam / Proton) için bir sürüm çıkarmayı planlıyoruz.

> [!CAUTION]
> ## MacOS
> MacOS için sürüm geliştirmeyi planlamıyoruz.
-----
![Sistem Gereksinimleri](https://raw.githubusercontent.com/JeaFrid/Stardew-Valmod/refs/heads/main/assets/github/valmod_3.png)

| Bileşen | Minimum | Önerilen |
| :--- | :--- | :--- |
| **İşletim Sistemi** | Windows 10 (64-bit) | Windows 11 |
| **İşlemci** | Intel Core i3 veya muadili | Intel Core i5 / AMD Ryzen 5 ve üzeri |
| **Bellek (RAM)** | 4 GB | 8 GB |
| **Depolama** | 200 MB (Uygulama) | 1 GB+ (İndirilecek modlar için) |
| **Ekran Kartı** | Standart Dahili Grafik | NVIDIA / AMD Harici Ekran Kartı |
| **Ağ** | İnternet Bağlantısı | Geniş Bant İnternet |

> [!WARNING]
> ## UNUTMAYIN!
> Valmod, içinde bir WebView2 çalıştırır. Bu nedenle Microsoft Edge tarayıcısının bilgisayarınızda mevcut olması gerekir.
> Özelleştirilmiş Windows sürümlerinde, Edge desteği olduğunu doğrulayın. Eğer Resmi Windows 10/11 kullanıyorsanız, gönül rahatlığıyla Valmod'u kurabilirsiniz.


![Bağımlılıklar](https://raw.githubusercontent.com/JeaFrid/Stardew-Valmod/refs/heads/main/assets/github/valmod_4.png)

> [!NOTE]
> ## Microsoft Edge / WebView2
> ### Neden?
> Edge Tarayıcısı, Windows'a bir web görünümü gömer. Valmod, bu web görünümünü kullanarak, sizin için bir NexusMod oturumu başlatır.

> [!NOTE]
> ## Stardew Valley - Steam İstemcisi
> ### Neden?
> Steam istemcisi olmayan Stardew Valley için mod desteği sınırlı olabilir. Test edilmedi.

----
## Geliştiriciler için Özel Tavsiyeler ve Ricalar
**Stardew Valmod, tamamen açık kaynak kodlu yapıda paylaşılmış olup, tüm geliştiricilerin kullanımına sonsuza dek açıktır.**
Valmod'un gelişimine katkı sağlayabilir, beni desteklemek [YouTube kanalıma](https://www.youtube.com/channel/UCtXPZf-2F5u1zTNzwYNUKWg) abone olabilirsiniz!

### Önce Oku, Sonra Geliştir.
Valmod, Flutter & Dart kullanılarak, bitsdojo_window ile pencere desteği sağlanarak geliştirilmiştir.

#### Kurulum ve Kullanım

##### Bağımlılık Detayları (pubspec.yaml Özeti)
| Kategori | Gereksinim | Versiyon / Detay | Açıklama |
| :--- | :--- | :--- | :--- |
| **Dil** | Dart SDK | `^3.10.4` | Projenin temel programlama dili. |
| **Framework** | Flutter SDK | `^3.10.x` | UI ve uygulama motoru. |
| **İşletim Sistemi** | Windows/macOS/Linux | En güncel kararlı sürüm | Geliştirme ortamı (Desktop desteği için Windows 10+ önerilir). |
| **IDE** | VS Code / Android Studio | Güncel Versiyon | Flutter ve Dart eklentileri kurulu olmalıdır. |
| **Masaüstü Araçları** | C++ Build Tools | Visual Studio 2022 | `bitsdojo_window` kullanımı için Windows masaüstü geliştirme araçları gereklidir. |
| **Bağlantı** | İnternet Erişimi | Gerekli | Paketlerin (pub.dev) ve yazı tiplerinin indirilmesi için. |
| **Veritabanı** | Hive DB | `^1.1.0` | NoSQL veritabanı için diskte okuma/yazma izni. |
| **Ağ Gereksinimi** | HTTP/HTTPS | `dio` & `webview` | API erişimi ve web içeriği görüntüleme için ağ izni. |
| **Dosya Sistemi** | I/O İzinleri | `path_provider` | Uygulama verilerinin saklanması için dosya sistemi erişimi. |
| **Arşivleme** | Zlib / Archive | `^4.0.7` | Mod dosyalarının açılması/sıkıştırılması için işlemci gücü ve bellek. |
| **Varlıklar (Assets)** | Asset Klasörleri | `/assets/image/`, `/assets/fonts/` | Proje klasör yapısında bu dizinlerin varlığı zorunludur. |
| **Uygulama İkonu** | Logo Kaynağı | `assets/image/logo.png` | `flutter_launcher_icons` için 256x256 px kaynak resim. |

---



| Paket Grubu | Ana Paketler | Kullanım Amacı |
| :--- | :--- | :--- |
| **UI & Görsel** | `google_fonts`, `cupertino_icons`, `delightful_toast` | Modern arayüz, font ve bildirim yönetimi. |
| **Veri & Depolama** | `dio`, `hive_flutter`, `shared_preferences` | API iletişimi ve yerel veri saklama. |
| **Sistem & Araçlar** | `url_launcher`, `clipboard`, `path_provider` | İşletim sistemi fonksiyonlarını tetikleme. |
| **Dosya İşleme** | `archive`, `html` | Mod dosyalarını işleme ve HTML verisi ayrıştırma. |
| **Masaüstü/Web** | `bitsdojo_window`, `flutter_inappwebview` | Masaüstü pencere yönetimi ve gömülü tarayıcı. |

#### 1. Ön Gereksinimler
Projeyi başlatmadan önce sisteminizde aşağıdakilerin kurulu olduğundan emin olun:
* **Flutter SDK:** `^3.10.4` veya üzeri.
* **Dart SDK:** `^3.10.4`.
* **Git:** Depoyu klonlamak için.
* **C++ Build Tools:** (Windows için) Visual Studio 2022 üzerinde "Desktop development with C++" iş yükü kurulu olmalıdır (`bitsdojo_window` paketinin derlenmesi için zorunludur).

#### 2. Kurulum Adımları

Aşağıdaki komutları sırasıyla terminalinizde çalıştırın:

```bash
# 1. Projeyi klonlayın
git clone [https://github.com/JeaFrid/Stardew-Valmod.git](https://github.com/JeaFrid/Stardew-Valmod.git)

# 2. Proje dizinine gidin
cd Stardew-Valmod

# 3. Bağımlılıkları yükleyin
flutter pub get

# 4. (Opsiyonel) İkonları oluşturun
# Eğer logo dosyası üzerinde değişiklik yaptıysanız çalıştırın:
flutter pub run flutter_launcher_icons
```
### Geçerli Bir Sebebin Yoksa Yeniden Dağıtma
Valmod, Stardew Valley topluluğuna, insanlık için **tamamen ücretsiz ve erişilebilir** olacak şekilde sunulmuş bir armağandır. Bu projenin arkasında; uykusuz geceler, binlerce satır kod, sayısız deneme-yanılma ve hepsinden önemlisi **büyük bir tutku** yatmaktadır.

Açık kaynak (Open Source) felsefesine yürekten inanıyoruz. Kodun şeffaf olması, öğrenilebilir olması ve denetlenebilir olması bizim için hayati önem taşır. Ancak, **"Açık Kaynak"** kavramı, **"Kopyala, Rengini Değiştir ve Sahiplen"** anlamına gelmemelidir.

Siz değerli geliştirici dostlarımızdan, projenin ve topluluğun geleceği için kritik bir ricamız var:

> [!CAUTION]
> **Lütfen bu projeyi olduğu gibi kopyalayıp (clone), üzerine hiçbir yapısal veya işlevsel yenilik katmadan; sadece adını, logosunu veya renk temasını değiştirerek "yeni bir uygulamaymış gibi" yayınlamayın.**

Bu ricamızın temelinde yatan sebepleri ve geliştirici etiğini aşağıda detaylandırdık:

#### 1. Topluluk Bütünlüğü ve Kullanıcı Deneyimi
Bir yazılımın, sadece görsel makyajı değiştirilmiş 10 farklı versiyonunun ("fork") ortalıkta dolaşması, en çok son kullanıcıya zarar verir.
* **Kafa Karışıklığı:** Kullanıcılar hangi sürümün "orijinal" veya "güvenli" olduğunu ayırt etmekte zorlanır.
* **Destek Sorunları:** Kopyalanmış ve bakımı yapılmayan sürümlerde çıkan hatalar, haksız bir şekilde orijinal projenin (Valmod) itibarını zedeler.
* **Güncelleme Karmaşası:** Biz Valmod'u güncellediğimizde, kopyalanmış "ölü" projeleri kullanan kullanıcılar bu yeniliklerden mahrum kalır.

#### 2. "JojaMart" Yaklaşımı Değil, "Halk Evi" Ruhu
Stardew Valley bize rekabeti değil, dayanışmayı öğretti. Güçlerimizi birleştirmek varken, neden enerjimizi bölüyoruz?
* **PR (Pull Request) Gönderin:** Eğer Valmod'da bir eksiklik görüyorsanız, bunu kendi kopyanızda düzeltip saklamak yerine, projeye bir **Pull Request** olarak gönderin.
* **İsminiz Yaşasın:** Kodunuz ana projeye eklendiğinde, sadece kendi küçük kitlenize değil, tüm Valmod kullanıcılarına ulaşmış olursunuz. Adınız, "Katkıda Bulunanlar" listesinde gururla yer alır. Gelin, Valmod'u *birlikte* mükemmelleştirelim.

#### 3. Geliştirici Motivasyonu ve Emeğe Saygı
Bir geliştiricinin en büyük yakıtı motivasyonudur. Bu projeyi yapmaya başlamadan önce YouTube topluluğuma danıştım ve birkaç gecemi buna ayırdım. Şimdiyse geliştirmeye devam ediyorum. Bana saygı duy ve yeniden dağıtırken tüm kurallara uyduğundan emin ol.

---

#### Peki, Hangi Durumlarda "Fork" Makuldür?
Elbette, özgür yazılımın doğasına aykırı değiliz. Yeniden dağıtımın mantıklı ve etik olduğu senaryolar şunlardır:

1.  **Kökten Mimari Değişiklik:** Eğer projenin altyapısını tamamen değiştirecek, Valmod'un mevcut vizyonundan tamamen farklı bir yöne (örneğin; sadece Stardew Valley değil, tüm Steam oyunlarını yönetecek bir yapıya) evrilecekseniz.
2.  **Terk Edilme Durumu:** Eğer bir gün Valmod geliştiricileri projeyi tamamen terk eder, güncelleme vermeyi keser ve arşivlerse; o zaman bayrağı devralıp projeyi yaşatmak için yeniden dağıtabilirsiniz.
3.  **Reddedilen Özellikler:** Eğer çok spesifik ve büyük bir özellik geliştirdiyseniz, ancak bu özellik Valmod'un ana vizyonuna uymadığı için tarafımızca reddedildiyse; kendi özelleştirilmiş sürümünüzü (orijinal projeye net bir şekilde referans vererek) yayınlamakta özgürsünüz.

**Özetle:** Amacınız geliştirmekse yanımızdasınız, amacınız sadece kopyalamaksa lütfen tekrar düşünün.

*Anlayışınız, emeğe saygınız ve işbirliğiniz için sonsuz teşekkürler. Kodlarınız hatasız, tarlalarınız bereketli olsun!* 🌾

## Özel Teşekkür
Bu projeyi geliştirmeden önce, gerçekten depresyonla mücadele eden biriydim. Sanırım hala öyleyim ama bu önemli değil. Valmod'un kodlarını yazarken, her eklediğim özelliği JeaValley'in Minnak Topluluğu'na ve Tuanna adlı canım arkadaşıma gönderiyordum. Onlar projenin mükemmel olduğunu söyleyerek motivasyonumu büyüttü. Onlara çok teşekkürler <3
