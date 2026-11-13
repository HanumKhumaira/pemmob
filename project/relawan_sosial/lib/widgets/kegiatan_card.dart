
import 'package:flutter/material.dart';

class KegiatanCard extends StatelessWidget {
  final String judul;
  final String lokasi;
  final String tanggal;
  final String kebutuhan;
  final String status;
  final VoidCallback onTap;

  const KegiatanCard({
    super.key,
    required this.judul,
    required this.lokasi,
    required this.tanggal,
    required this.kebutuhan,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool dibuka = status.toUpperCase() == 'DIBUKA';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EB),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFD8D2C6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9E5DA),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'BENCANA SOSIAL',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF102D20),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: dibuka
                      ? const Color(0xFFDCE9DC)
                      : const Color(0xFFEAE0D8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: dibuka
                        ? const Color(0xFF102D20)
                        : const Color(0xFF8A472B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            judul,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF202820),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Color(0xFF666B63),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  lokasi,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666B63),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: Color(0xFF666B63),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  tanggal,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666B63),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            kebutuhan,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFFB54725),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lihat detail kegiatan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF102D20),
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: Color(0xFF102D20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
