import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sesion14_textformfield_validacion/main.dart';

void main() {
  testWidgets('valida el título antes de agregar la tarea', (tester) async {
    await tester.pumpWidget(const AplicacionTareas());

    await tester.tap(find.byKey(const Key('botonNuevaTarea')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('campoTitulo')), '   ');
    await tester.tap(find.byKey(const Key('botonGuardar')));
    await tester.pump();
    expect(find.text('El título es obligatorio'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('campoTitulo')), 'Ir');
    await tester.tap(find.byKey(const Key('botonGuardar')));
    await tester.pump();
    expect(
      find.text('El título debe tener al menos 3 caracteres'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const Key('campoTitulo')),
      'Preparar informe',
    );
    await tester.tap(find.byKey(const Key('botonGuardar')));
    await tester.pumpAndSettle();

    expect(find.text('Preparar informe'), findsOneWidget);
    expect(find.text('0 de 1 tareas completadas'), findsOneWidget);
  });

  testWidgets('permite completar y eliminar una tarea registrada', (
    tester,
  ) async {
    await tester.pumpWidget(const AplicacionTareas());

    await tester.tap(find.byKey(const Key('botonNuevaTarea')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('campoTitulo')),
      'Estudiar Flutter',
    );
    await tester.tap(find.byKey(const Key('botonGuardar')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('tarea_0')));
    await tester.pump();
    expect(find.text('1 de 1 tareas completadas'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('eliminar_0')));
    await tester.pump();
    expect(find.text('Estudiar Flutter'), findsNothing);
    expect(find.text('0 de 0 tareas completadas'), findsOneWidget);
  });
}
