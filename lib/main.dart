import 'package:flutter/material.dart';

const kBlue = Color(0xFF0D477A);
const kGreen = Color(0xFF16845B);
const kYellow = Color(0xFFE5A900);
const kBg = Color(0xFFF2F7FA);
const kWhite = Color(0xFFFFFFFF);

void main() => runApp(const EnergiKuApp());

class EnergiKuApp extends StatelessWidget {
  const EnergiKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EnergiKu',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBg,
        fontFamily: 'Roboto',
      ),
      home: const EnergiKuDashboard(),
    );
  }
}

class EnergiKuDashboard extends StatefulWidget {
  const EnergiKuDashboard({super.key});

  @override
  State<EnergiKuDashboard> createState() => _EnergiKuDashboardState();
}

class _EnergiKuDashboardState extends State<EnergiKuDashboard> {
  static const _challenges = [
    (Icons.wb_sunny, 'Energi Surya', 'Kenali manfaat panel surya.', 50, kYellow),
    (Icons.lightbulb_outline, 'Hemat Listrik', 'Matikan perangkat yang tidak digunakan.', 30, kBlue),
    (Icons.recycling, 'Kurangi Plastik', 'Gunakan tas belanja ramah lingkungan.', 40, kGreen),
  ];

  final _liked = [false, false, true];
  
  // --- STATE ZOOM / PINCH INTERAKTIF ---
  double _illusScale = 1.0;
  double _illusBase = 1.0;

  // State Fitur Lain
  int _actIndex = 0;
  double _actDrag = 0;
  final _actDone = [true, false];

  int _totalPoints = 120;
  int _selectedCategoryIndex = 0;
  double _kwhUsage = 150.0;

  final _categoryDetails = [
    ('Surya', Icons.wb_sunny, kYellow, '45%', 'Panel surya atap menghasilkan 144 kWh bulan ini.'),
    ('Angin', Icons.air, kBlue, '25%', 'Turbin angin mikro menyuplai 80 kWh daya cadangan.'),
    ('Air', Icons.water_drop, Colors.blue, '20%', 'PLTA skala mikro menyumbang 64 kWh.'),
    ('Biomassa', Icons.grass, kGreen, '10%', 'Pengolahan sampah organik menghasilkan 32 kWh.'),
  ];

  BoxDecoration _box({Color? color}) => BoxDecoration(
        color: color ?? kWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  Widget _sectionHead(String title, IconData icon, {String? action, VoidCallback? onActionTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Icon(icon, color: kGreen, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold, color: kBlue)),
          ),
          if (action != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(action,
                  style: const TextStyle(
                      color: kGreen, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
        ],
      ),
    );
  }

  Widget _illusScene() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue.shade100, kGreen.withValues(alpha: 0.35)],
            ),
          ),
        ),
        const Positioned(top: 12, right: 24, child: Icon(Icons.wb_sunny, color: kYellow, size: 36)),
        const Positioned(top: 28, left: 20, child: Icon(Icons.landslide, color: Colors.blueGrey, size: 40)),
        const Positioned(top: 36, right: 70, child: Icon(Icons.air, color: kBlue, size: 28)),
        const Positioned(bottom: 48, left: 16, child: Icon(Icons.solar_power, color: kYellow, size: 32)),
        const Positioned(bottom: 40, right: 20, child: Icon(Icons.wind_power, color: kBlue, size: 34)),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.water_drop, color: Colors.blue.shade400, size: 28),
              const SizedBox(width: 8),
              Icon(Icons.waves, color: Colors.blue.shade300, size: 32),
            ],
          ),
        ),
      ],
    );
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.notifications_active, color: kGreen),
            SizedBox(width: 8),
            Text('Notifikasi Eco', style: TextStyle(fontSize: 16, color: kBlue)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.star, color: kYellow),
              title: Text('Bonus Poin!', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: Text('Kamu mendapatkan +30 poin dari tantangan Hemat Listrik.', style: TextStyle(fontSize: 11)),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.eco, color: kGreen),
              title: Text('Target Tercapai', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: Text('Pengurangan emisi CO₂ minggu ini naik 12%.', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: kGreen)),
          ),
        ],
      ),
    );
  }

  void _showRewardStore() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tukar Poin Eco-Reward',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kBlue)),
                Chip(
                  avatar: const Icon(Icons.stars, color: kYellow, size: 18),
                  label: Text('$_totalPoints Poin', style: const TextStyle(fontWeight: FontWeight.bold, color: kBlue)),
                  backgroundColor: kYellow.withValues(alpha: 0.2),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _rewardTile('Voucher Listrik Rp 20.000', '100 Poin', Icons.electric_bolt, Colors.orange, 100),
            const SizedBox(height: 8),
            _rewardTile('Tanam 1 Bibit Pohon', '150 Poin', Icons.park, kGreen, 150),
          ],
        ),
      ),
    );
  }

  Widget _rewardTile(String title, String cost, IconData icon, Color color, int pointsReq) {
    bool canRedeem = _totalPoints >= pointsReq;
    return Card(
      elevation: 0,
      color: kBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kBlue)),
        subtitle: Text(cost, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: canRedeem ? kGreen : Colors.grey.shade400,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: canRedeem
              ? () {
                  setState(() => _totalPoints -= pointsReq);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Berhasil menukar "$title"! 🎉'), backgroundColor: kGreen),
                  );
                }
              : null,
          child: const Text('Tukar', style: TextStyle(color: kWhite, fontSize: 12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final act = _actIndex == 0
        ? ('Menghemat Listrik', Icons.bolt, 10)
        : ('Menanam Pohon', Icons.park, 20);
    final done = _actDone[_actIndex];
    final selectedCat = _categoryDetails[_selectedCategoryIndex];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: kWhite,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8)
                        ],
                      ),
                      child: const Icon(Icons.eco, color: kGreen),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EnergiKu',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kBlue)),
                          Text('Energi Bersih, Masa Depan Cerah',
                              style: TextStyle(fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _showRewardStore,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: kYellow.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: kYellow, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.stars, color: kYellow, size: 16),
                            const SizedBox(width: 4),
                            Text('$_totalPoints Poin',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kBlue)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: _showNotificationDialog,
                          icon: const Icon(Icons.notifications_none, color: kBlue),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Greeting
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Halo, semangat!',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: kBlue)),
                          SizedBox(height: 4),
                          Text(
                            'Setiap langkah kecil kamu, berdampak besar untuk bumi. 🍃',
                            style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6)
                        ],
                      ),
                      child: const Text('🤏 Pinch / Ketuk 2x\nZoom Gambar',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9, color: kBlue, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),

              // Stats + Ilustrasi Interaktif Zoom (Scale / Pinch)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: kWhite,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                    color: Color(0xFFFFF3CD), shape: BoxShape.circle),
                                child: const Icon(Icons.bolt, color: kYellow, size: 22),
                              ),
                              const SizedBox(height: 10),
                              const Text('Total Energi Hijau',
                                  style: TextStyle(fontSize: 12, color: Colors.black54)),
                              const Text('320 kWh',
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: kBlue)),
                              const SizedBox(height: 6),
                              const Row(
                                children: [
                                  Icon(Icons.arrow_upward, size: 14, color: kGreen),
                                  SizedBox(width: 2),
                                  Flexible(
                                    child: Text('20 kWh dari minggu lalu',
                                        style: TextStyle(fontSize: 11, color: kGreen)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        clipBehavior: Clip.antiAlias,
                        child: 
                        GestureDetector(
                          // 1. PINCH / SCALE GESTURE
                          onScaleStart: (_) => _illusBase = _illusScale,
                          onScaleUpdate: (d) => setState(() {
                            _illusScale = (_illusBase * d.scale).clamp(0.8, 2.5);
                          }),
                          onScaleEnd: (_) => _illusBase = _illusScale,
                          
                          // 2. DOUBLE TAP UNTUK QUICK ZOOM TOGGLE
                          onDoubleTap: () => setState(() {
                            _illusScale = _illusScale > 1.2 ? 1.0 : 1.8;
                          }),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 150,
                                child: Transform.scale(
                                  scale: _illusScale,
                                  alignment: Alignment.center,
                                  child: _illusScene(),
                                ),
                              ),
                              // Control Zoom Tombol & Indikator Ukuran
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => setState(() => _illusScale = (_illusScale - 0.2).clamp(0.8, 2.5)),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                                        child: const Icon(Icons.remove, color: Colors.white, size: 14),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    InkWell(
                                      onTap: () => setState(() => _illusScale = (_illusScale + 0.2).clamp(0.8, 2.5)),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                                        child: const Icon(Icons.add, color: Colors.white, size: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${_illusScale.toStringAsFixed(1)}x',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Energi Terbarukan (Interaktif)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: kWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.eco, color: kGreen, size: 20),
                            SizedBox(width: 8),
                            Text('Energi Terbarukan',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kBlue,
                                    fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Sentuh kategori untuk melihat detail kontribusi.',
                            style: TextStyle(
                                fontSize: 12, color: Colors.black.withValues(alpha: 0.5))),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(4, (index) {
                            final cat = _categoryDetails[index];
                            final isSelected = _selectedCategoryIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedCategoryIndex = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? cat.$3.withValues(alpha: 0.2) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? cat.$3 : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: _cat(cat.$2, cat.$1, cat.$3),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selectedCat.$3.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Text(selectedCat.$4,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: selectedCat.$3)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(selectedCat.$5,
                                    style: const TextStyle(fontSize: 11, color: kBlue, height: 1.3)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Kalkulator Simulasi Hemat Energi
              _sectionHead('Kalkulator Simulasi Hemat Energi', Icons.calculate),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _box(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimasi Listrik Bulanan:',
                              style: TextStyle(fontSize: 12, color: Colors.black54)),
                          Text('${_kwhUsage.round()} kWh/bulan',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kBlue)),
                        ],
                      ),
                      Slider(
                        value: _kwhUsage,
                        min: 50,
                        max: 500,
                        activeColor: kGreen,
                        inactiveColor: Colors.grey.shade200,
                        onChanged: (val) => setState(() => _kwhUsage = val),
                      ),
                      const Divider(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Hemat Tagihan', style: TextStyle(fontSize: 10, color: Colors.black54)),
                              Text('Rp ${(_kwhUsage * 1444 * 0.2).round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kGreen)),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Reduksi Emisi CO₂', style: TextStyle(fontSize: 10, color: Colors.black54)),
                              Text('${(_kwhUsage * 0.85).toStringAsFixed(1)} kg',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kBlue)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              _sectionHead('Tantangan Hari Ini', Icons.emoji_events, action: 'Lihat Semua >'),
              SizedBox(
                height: 168,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final c = _challenges[i];
                    final fav = _liked[i];
                    return 
                    GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          _liked[i] = !fav;
                          if (_liked[i]) {
                            _totalPoints += c.$4;
                          } else {
                            _totalPoints -= c.$4;
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_liked[i]
                                ? 'Tantangan difavoritkan! +${c.$4} Poin ditambah.'
                                : 'Tantangan dihapus dari favorit.'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: fav ? kGreen : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          color: fav ? kGreen.withValues(alpha: 0.08) : kWhite,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(c.$1, color: c.$5, size: 28),
                                    Icon(
                                      fav ? Icons.favorite : Icons.favorite_border,
                                      color: fav ? kGreen : Colors.grey.shade400,
                                      size: 22,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(c.$2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kBlue,
                                        fontSize: 14)),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: Text(c.$3,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.black54)),
                                ),
                                Text('⭐ +${c.$4} poin',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: kBlue)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              _sectionHead('Aktivitas Terbaru', Icons.schedule, action: 'Lihat Semua >'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        _actIndex = (_actIndex - 1).clamp(0, 1);
                        _actDrag = 0;
                      }),
                      icon: const Icon(Icons.chevron_left, color: kBlue),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onHorizontalDragStart: (_) => _actDrag = 0,
                        onHorizontalDragUpdate: (d) =>
                            setState(() => _actDrag += d.delta.dx),
                        onHorizontalDragEnd: (_) {
                          setState(() {
                            if (_actDrag > 70) _actDone[_actIndex] = true;
                            if (_actDrag < -70) _actDone[_actIndex] = false;
                            if (_actDrag < -120 && _actIndex < 1) {
                              _actIndex = 1;
                            } else if (_actDrag > 120 && _actIndex > 0) {
                              _actIndex = 0;
                            }
                            _actDrag = 0;
                          });
                        },
                        child: Transform.translate(
                          offset: Offset(_actDrag.clamp(-80.0, 80.0), 0),
                          child: Card(
                            elevation: 0,
                            color: done
                                ? kGreen.withValues(alpha: 0.12)
                                : kWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: done ? kGreen : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        done ? kGreen : kYellow.withValues(alpha: 0.25),
                                    child: Icon(act.$2,
                                        color: done ? kWhite : kGreen),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(act.$1,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kBlue)),
                                        const Text('Aktivitas simulasi',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.black54)),
                                        Text('⭐ +${act.$3} poin',
                                            style: const TextStyle(
                                                fontSize: 12, color: kBlue)),
                                      ],
                                    ),
                                  ),
                                  if (done)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: kGreen,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check, color: kWhite, size: 16),
                                          SizedBox(width: 4),
                                          Text('Selesai',
                                              style: TextStyle(
                                                  color: kWhite,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    )
                                  else
                                    const Text('Geser → selesai',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.black45)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() {
                        _actIndex = (_actIndex + 1).clamp(0, 1);
                        _actDrag = 0;
                      }),
                      icon: const Icon(Icons.chevron_right, color: kBlue),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2,
                  (i) => Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 4),
                    width: i == _actIndex ? 10 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _actIndex ? kGreen : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              _sectionHead('Dampak Lingkungan', Icons.eco),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: _impact('CO₂', 'Pengurangan Emisi CO₂', '12,5 kg', 0.62, kGreen)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _impact('⚡', 'Energi Bersih Dihasilkan', '48 kWh', 0.48, kYellow)),
                    const SizedBox(width: 8),
                    Expanded(child: _impact('🌳', 'Pohon Tertanam', '8 pohon', 0.40, kGreen)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [kGreen.withValues(alpha: 0.85), kGreen],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kWhite.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.park, color: kWhite),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          '“Energi terbarukan bukan hanya solusi, tapi investasi untuk generasi mendatang.” 🍃',
                          style: TextStyle(
                              color: kWhite,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cat(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: kBlue)),
      ],
    );
  }

  Widget _impact(String badge, String title, String value, double prog, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Text(badge, style: TextStyle(fontSize: 10, color: color)),
          ),
          const SizedBox(height: 8),
          Text(title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9, color: Colors.black54, height: 1.2)),
          Text(value,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold, color: kBlue)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: prog,
              minHeight: 5,
              backgroundColor: Colors.grey.shade200,
              color: color,
            ),
          ),
          Text('${(prog * 100).round()}%',
              style: TextStyle(fontSize: 9, color: color)),
        ],
      ),
    );
  }
}