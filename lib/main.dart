import 'package:flutter/material.dart';

void main() {
  runApp(const AplicacionTareas());
}

class AplicacionTareas extends StatelessWidget {
  const AplicacionTareas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sesión 14',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PantallaTareas(),
    );
  }
}

class Tarea {
  Tarea({required this.titulo, this.completada = false});

  final String titulo;
  bool completada;
}

class PantallaTareas extends StatefulWidget {
  const PantallaTareas({super.key});

  @override
  State<PantallaTareas> createState() => _PantallaTareasState();
}

class _PantallaTareasState extends State<PantallaTareas> {
  final List<Tarea> _tareas = [];

  int get _cantidadCompletadas {
    return _tareas.where((tarea) => tarea.completada).length;
  }

  void _agregarTarea(String titulo) {
    setState(() {
      _tareas.add(Tarea(titulo: titulo));
    });
  }

  void _cambiarEstado(int indice, bool? valor) {
    setState(() {
      _tareas[indice].completada = valor ?? false;
    });
  }

  void _eliminarTarea(int indice) {
    setState(() {
      _tareas.removeAt(indice);
    });
  }

  void _mostrarFormulario() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return FormularioRegistroTarea(onGuardar: _agregarTarea);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividad evaluable - Sesión 14'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('botonNuevaTarea'),
        onPressed: _mostrarFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Formulario de registro de tarea',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$_cantidadCompletadas de ${_tareas.length} tareas completadas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _tareas.isEmpty
                  ? const _ListaVacia()
                  : ListView.builder(
                      key: const Key('listaTareas'),
                      itemCount: _tareas.length,
                      itemBuilder: (context, indice) {
                        final tarea = _tareas[indice];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: CheckboxListTile(
                            key: ValueKey('tarea_$indice'),
                            value: tarea.completada,
                            onChanged: (valor) =>
                                _cambiarEstado(indice, valor),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              tarea.titulo,
                              style: TextStyle(
                                decoration: tarea.completada
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: tarea.completada
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                            ),
                            secondary: IconButton(
                              key: ValueKey('eliminar_$indice'),
                              tooltip: 'Eliminar tarea',
                              onPressed: () => _eliminarTarea(indice),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormularioRegistroTarea extends StatefulWidget {
  const FormularioRegistroTarea({super.key, required this.onGuardar});

  final ValueChanged<String> onGuardar;

  @override
  State<FormularioRegistroTarea> createState() =>
      _FormularioRegistroTareaState();
}

class _FormularioRegistroTareaState
    extends State<FormularioRegistroTarea> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controladorTitulo = TextEditingController();

  String? _validarTitulo(String? value) {
    final titulo = value?.trim() ?? '';

    if (titulo.isEmpty) {
      return 'El título es obligatorio';
    }

    if (titulo.length < 3) {
      return 'El título debe tener al menos 3 caracteres';
    }

    return null;
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      widget.onGuardar(_controladorTitulo.text.trim());
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controladorTitulo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registrar nueva tarea'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: TextFormField(
            key: const Key('campoTitulo'),
            controller: _controladorTitulo,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Título de la tarea',
              hintText: 'Mínimo 3 caracteres',
              prefixIcon: Icon(Icons.edit_note),
              border: OutlineInputBorder(),
            ),
            validator: _validarTitulo,
            onFieldSubmitted: (_) => _guardar(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          key: const Key('botonGuardar'),
          onPressed: _guardar,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Guardar'),
        ),
      ],
    );
  }
}

class _ListaVacia extends StatelessWidget {
  const _ListaVacia();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('No hay tareas. Registra la primera.'),
        ],
      ),
    );
  }
}
