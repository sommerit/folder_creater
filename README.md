# Folder Creator

Ein Bash-Skript zur dynamischen Erstellung von Verzeichnisstrukturen basierend auf Benutzereingaben und einer YAML-Konfigurationsdatei.

## Übersicht

Dieses Projekt ermöglicht es, Verzeichnisse basierend auf vordefinierten Umgebungen, Netzwerkzonen und Tools zu erstellen. Die Konfiguration ist in der `config.yaml` Datei ausgelagert, was eine einfache Anpassung und Erweiterung ohne Änderung des Skriptcodes ermöglicht.

## Funktionen

- **Dynamische Menüs**: Die Auswahlmöglichkeiten werden aus der `config.yaml` Datei geladen.
- **Flexibilität**: Neue Umgebungen, Netzwerkzonen oder Tools können einfach hinzugefügt werden.
- **Benutzerfreundlich**: Klare Eingabeaufforderungen führen durch den Prozess.
- **Anpassbare Verzeichnisstruktur**: Spezielle Pfade für bestimmte Umgebungen (z.B. `SERVICE` und `RUNTIME`).

## Installation

1. **Repository klonen**:

   ```bash
   git clone https://github.com/sommerit/folder_creater.git

## DEMO

[![asciinema CLI
demo](https://asciinema.org/a/p8IXZnQadtsuY8ryqYxR9W2g9.svg)](https://asciinema.org/a/p8IXZnQadtsuY8ryqYxR9W2g9?autoplay=1)
