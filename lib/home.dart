import 'dart:math';
import 'package:flutter/material.dart';

import 'formas.dart';
import 'modelos.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ModeloNodo> vNodo = [];
  List<ModeloLinea> vLineas = [];
  ModeloNodo? nodoInicial;
  ModeloNodo? nodoFinal;
  int modo = -1;
  int click = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Stack(
            children: [
              CustomPaint(
                painter: Nodo(vNodo),
              ),
              CustomPaint(
                painter: Lineas(vLineas),
              ),
              GestureDetector(
                onPanDown: (des) {
                  setState(() {
                    switch (modo) {
                      case 1:
                        vNodo.add(ModeloNodo(
                            des.globalPosition.dx,
                            des.globalPosition.dy,
                            "${vNodo.length + 1}",
                            30,
                            const Color.fromARGB(255, 11, 106, 214)));
                        break;
                      case 2:
                        try {
                          for (var nodo in vNodo) {
                            if (sqrt(pow(nodo.x - des.globalPosition.dx, 2) +
                                    pow(nodo.y - des.globalPosition.dy, 2)) <
                                nodo.radio) {
                              vNodo.remove(nodo);

                              vLineas.removeWhere((linea) =>
                                  linea.x1 == nodo.x && linea.y1 == nodo.y ||
                                  linea.x2 == nodo.x && linea.y2 == nodo.y);

                              for (int i = 0; i < vNodo.length; i++) {
                                vNodo[i].nombre = "${i + 1}";
                              }
                            }
                          }
                        } catch (e) {}
                        break;
                      case 4:
                        try {
                          for (var nodo in vNodo) {
                            if (sqrt(pow(nodo.x - des.globalPosition.dx, 2) +
                                    pow(nodo.y - des.globalPosition.dy, 2)) <
                                nodo.radio) {
                              click++;
                              if (click == 1) {
                                nodoInicial = nodo;
                              } else if (click == 2) {
                                nodoFinal = nodo;
                                print(
                                    "Nodo Inicial: ${nodoInicial!.nombre} Nodo Final: ${nodoFinal!.nombre}");

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      double peso = 0;
                                      return AlertDialog(
                                        title: Text("Ingrese el peso"),
                                        content: TextField(
                                          onChanged: (value) {
                                            peso = double.tryParse(value) ?? 0;
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                vLineas.add(ModeloLinea(
                                                  vNodo[vNodo.indexOf(
                                                          nodoInicial!)]
                                                      .x,
                                                  vNodo[vNodo.indexOf(
                                                          nodoInicial!)]
                                                      .y,
                                                  vNodo[vNodo
                                                          .indexOf(nodoFinal!)]
                                                      .x,
                                                  vNodo[vNodo
                                                          .indexOf(nodoFinal!)]
                                                      .y,
                                                  "0",
                                                )..peso = peso);
                                                click = 0;
                                                Navigator.pop(context);
                                              },
                                              child: Text("Aceptar"))
                                        ],
                                      );
                                    });
                              }
                            }
                          }
                        } catch (e) {}
                        break;
                      case 5:
                        int click = 0;
                        ModeloNodo? nodoInicial;
                        ModeloNodo? nodoFinal;
                        vLineas.forEach((linea) {
                          if (sqrt(pow(linea.x1 - des.globalPosition.dx, 2) +
                                  pow(linea.y1 - des.globalPosition.dy, 2)) <
                              20) {
                            if (click == 0) {
                              nodoInicial = vNodo.firstWhere((nodo) =>
                                  nodo.x == linea.x1 && nodo.y == linea.y1);
                              click++;
                            } else if (click == 1) {
                              nodoFinal = vNodo.firstWhere((nodo) =>
                                  nodo.x == linea.x2 && nodo.y == linea.y2);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Ingrese el peso"),
                                      content: TextField(
                                        onChanged: (value) {
                                          linea.peso = double.parse(value);
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Aceptar"))
                                      ],
                                    );
                                  });
                              click = 0;
                            }
                          }
                        });
                        break;
                    }
                  });
                },
                onPanUpdate: (des) {
                  setState(() {
                    switch (modo) {
                      case 3:
                        for (var nodo in vNodo) {
                          if (sqrt(pow(nodo.x - des.globalPosition.dx, 2) +
                                  pow(nodo.y - des.globalPosition.dy, 2)) <
                              nodo.radio) {
                            for (var i = 0; i < vLineas.length; i++) {
                              if (vLineas[i].x1 == nodo.x &&
                                  vLineas[i].y1 == nodo.y) {
                                vLineas[i].x1 = des.globalPosition.dx;
                                vLineas[i].y1 = des.globalPosition.dy;

                                vLineas[i].distancia =
                                    "${(sqrt(pow(vLineas[i].x1 - vLineas[i].x2, 2) + pow(vLineas[i].y1 - vLineas[i].y2, 2))).toStringAsFixed(2)}";
                              }
                              if (vLineas[i].x2 == nodo.x &&
                                  vLineas[i].y2 == nodo.y) {
                                vLineas[i].x2 = des.globalPosition.dx;
                                vLineas[i].y2 = des.globalPosition.dy;

                                vLineas[i].distancia =
                                    "${(sqrt(pow(vLineas[i].x1 - vLineas[i].x2, 2) + pow(vLineas[i].y1 - vLineas[i].y2, 2))).toStringAsFixed(2)}";
                              }
                            }
                            nodo.x = des.globalPosition.dx;
                            nodo.y = des.globalPosition.dy;
                          }
                        }
                        break;
                    }
                  });
                },
              )
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: const Color.fromARGB(255, 0, 204, 255),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      modo = 1;
                    });
                  },
                  icon: Icon(Icons.add,
                      color: modo == 1
                          ? Colors.green.shade900
                          : Colors.red.shade900),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        modo = 2;
                      });
                    },
                    icon: Icon(Icons.delete,
                        color: modo == 2
                            ? Colors.green.shade900
                            : Colors.red.shade900)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        modo = 3;
                      });
                    },
                    icon: Icon(Icons.move_down,
                        color: modo == 3
                            ? Colors.green.shade900
                            : Colors.red.shade900)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        modo = 4;
                      });
                    },
                    icon: Icon(Icons.link,
                        color: modo == 4
                            ? Colors.green.shade900
                            : Colors.red.shade900)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        modo = 5;
                      });
                    },
                    icon: Icon(Icons.edit,
                        color: modo == 5
                            ? Colors.green.shade900
                            : Colors.red.shade900)),
              ],
            ),
          )),
    );
  }
}
