class EducationRepository {
  // Lista de níveis de educação
  static List<String> educationLevels = [
    "Ensino Médio Completo",
    "Ensino Superior Cursando",
    "Ensino Superior Completo",
    "Pós-graduação Cursando",
    "Pós-graduação Completa",
    "Mestrado Cursando",
    "Mestrado Completo",
    "Doutorado Cursando",
    "Doutorado Completo",
    "Curso de Formação Específica Cursando",
    "Curso de Formação Específica Completa",
  ];

  // Geração de lista de semestres
  static List<String> semesters =
      List.generate(12, (int index) => '${index + 1}º semestre')..add('Nenhum');
}
