class LocalCommittee {
  final String id;
  final String name;

  LocalCommittee({required this.id, required this.name});

  factory LocalCommittee.fromFirestore(Map<String, dynamic> data, String id) {
    return LocalCommittee(
      id: id,
      name: data['name'] ?? '',
    );
  }
}
