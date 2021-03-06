/*
 * ProgressPanel.vala
 *
 * Copyright 2017 Tony George <teejeetech@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 *
 */


using Gtk;
using Gee;

using TeeJee.Logging;
using TeeJee.FileSystem;
using TeeJee.JsonHelper;
using TeeJee.ProcessHelper;
using TeeJee.GtkHelper;
using TeeJee.System;
using TeeJee.Misc;

public abstract class ProgressPanel : Gtk.Box {

	public Gee.ArrayList<FileItem> items;
	public FileActionType action_type;
	public FileItem source;
	public FileItem destination;

	protected Gtk.Box contents;

	// parents
	protected FileViewPane pane;
	protected MainWindow window {
		get {
			return App.main_window;
		}
	}

	protected bool aborted = false;
	protected uint tmr_status = 0;

	public signal void task_complete();

	public ProgressPanel(FileViewPane _pane, Gee.ArrayList<FileItem>? _items, FileActionType _action){
		//base(Gtk.Orientation.VERTICAL, 6); // issue with vala
		Object(orientation: Gtk.Orientation.VERTICAL, spacing: 6); // work-around
		margin = 6;

		var frame = new Gtk.Frame(null);
		add(frame);

		contents = new Gtk.Box(Orientation.VERTICAL, 6);
		contents.margin = 6;
		frame.add(contents);

		set_pane(_pane);
		set_selected_items(_items);
		set_action(_action);

		init_ui();

		show_all();
	}

	public void set_selected_items(Gee.ArrayList<FileItem>? _items){
		items = _items;
	}

	public void set_action(FileActionType selected_action){
		action_type = selected_action;
	}

	public void set_source(FileItem source_item){
		// create new object to avoid conflicts between multiple running operations
		source = new FileItem.from_path(source_item.file_path);
	}

	public void set_destination(FileItem dest_item){
		// create new object to avoid conflicts between multiple running operations
		destination = new FileItem.from_path(dest_item.file_path);
	}

	public void set_pane(FileViewPane parent_pane){
		pane = parent_pane;
	}

	public void stop_status_timer(){
		if (tmr_status > 0){
			Source.remove(tmr_status);
			tmr_status = 0;
		}
	}
	
	public abstract void init_ui();
	
	public abstract void execute();

	public abstract void init_status();
	
	public abstract void start_task();

	public abstract bool update_status();
	
	public abstract void cancel();

	public abstract void finish();
}




