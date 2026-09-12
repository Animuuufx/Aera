(function () {
    'use strict';

    function onReady(callback) {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', callback, { once: true });
        } else {
            callback();
        }
    }

    function make(tag, className, text) {
        var node = document.createElement(tag);
        if (className) node.className = className;
        if (text !== undefined && text !== null) node.textContent = text;
        return node;
    }

    function button(label, className) {
        var node = make('button', 'exp-btn' + (className ? ' ' + className : ''), label);
        node.type = 'button';
        return node;
    }

    function humanize(key) {
        var text = String(key || '')
            .replace(/([a-z0-9])([A-Z])/g, '$1 $2')
            .replace(/([A-Z]+)([A-Z][a-z])/g, '$1 $2')
            .replace(/[_-]+/g, ' ')
            .replace(/\s+/g, ' ')
            .trim();
        if (!text) return 'Value';
        return text.charAt(0).toUpperCase() + text.slice(1);
    }

    function isPlainObject(value) {
        return value !== null && typeof value === 'object' && !Array.isArray(value);
    }

    function cloneValue(value) {
        return JSON.parse(JSON.stringify(value));
    }

    function blankLike(value) {
        if (Array.isArray(value)) return [];
        if (isPlainObject(value)) {
            var result = {};
            Object.keys(value).forEach(function (key) {
                result[key] = blankLike(value[key]);
            });
            return result;
        }
        if (typeof value === 'number') return 0;
        if (typeof value === 'boolean') return false;
        if (value === null) return null;
        return '';
    }

    function firstJsonNode(parent) {
        if (!parent) return null;
        for (var i = 0; i < parent.children.length; i += 1) {
            if (parent.children[i].classList.contains('exp-json-node')) return parent.children[i];
        }
        return null;
    }

    onReady(function () {
        var form = document.querySelector('form[data-admin-data-form][data-editor-kind="expedition_weeks"]');
        if (!form) return;

        var output = form.querySelector('textarea[name="Content"], input[name="Content"]');
        if (!output) return;

        var field = output.closest('.db-field');
        if (!field) return;

        var originalText = String(output.value || '').trim();
        var parsed;
        try {
            parsed = originalText === '' ? [] : JSON.parse(originalText);
        } catch (error) {
            field.classList.add('expedition-content-field');
            var bad = make('div', 'expedition-editor-error');
            bad.textContent = 'The saved Content is not valid JSON yet, so the structured editor cannot safely open it. Fix the JSON below once, save it, then reopen this page.';
            field.insertBefore(bad, output);
            output.hidden = false;
            output.rows = 18;
            return;
        }

        field.classList.add('expedition-content-field');
        output.hidden = true;
        output.setAttribute('data-expedition-json-output', '1');

        var shell = make('div', 'expedition-editor-shell');
        var intro = make('div', 'expedition-editor-intro');
        var introCopy = make('div');
        introCopy.appendChild(make('strong', '', 'Expedition Week Content'));
        introCopy.appendChild(make('p', '', 'Edit every map, monster, reward, rule, coordinate, flag, and nested value with normal inputs. The page rebuilds the Content JSON automatically when you save.'));
        intro.appendChild(introCopy);

        var toolbar = make('div', 'expedition-editor-toolbar');
        var toolbarLeft = make('div', 'expedition-editor-toolbar-left');
        var toolbarRight = make('div', 'expedition-editor-toolbar-right');
        var count = make('span', 'expedition-editor-count');
        var addEntryButton = button('+ Add Entry', 'exp-btn-primary');
        var expandButton = button('Expand All');
        var collapseButton = button('Collapse All');
        toolbarLeft.appendChild(addEntryButton);
        toolbarLeft.appendChild(count);
        toolbarRight.appendChild(expandButton);
        toolbarRight.appendChild(collapseButton);
        toolbar.appendChild(toolbarLeft);
        toolbar.appendChild(toolbarRight);

        var structured = make('div', 'expedition-structured-editor');
        var advanced = make('details', 'expedition-advanced');
        var advancedSummary = make('summary', '', 'Advanced: Raw JSON');
        var advancedBody = make('div', 'expedition-advanced-body');
        var raw = make('textarea', 'expedition-raw-json');
        raw.spellcheck = false;
        raw.setAttribute('aria-label', 'Raw expedition JSON');
        var rawActions = make('div', 'expedition-editor-toolbar');
        var rawLeft = make('div', 'expedition-editor-toolbar-left');
        var applyRawButton = button('Apply Raw JSON', 'exp-btn-primary');
        var formatRawButton = button('Format JSON');
        var status = make('div', 'expedition-json-status');
        rawLeft.appendChild(applyRawButton);
        rawLeft.appendChild(formatRawButton);
        rawActions.appendChild(rawLeft);
        rawActions.appendChild(status);
        advancedBody.appendChild(raw);
        advancedBody.appendChild(rawActions);
        advanced.appendChild(advancedSummary);
        advanced.appendChild(advancedBody);

        shell.appendChild(intro);
        shell.appendChild(toolbar);
        shell.appendChild(structured);
        shell.appendChild(advanced);
        field.appendChild(shell);

        var topHeaderParagraph = document.querySelector('.admin-top p');
        if (topHeaderParagraph) {
            topHeaderParagraph.textContent = 'Edit the weekly expedition with structured fields. Content JSON is generated automatically.';
        }

        var currentRoot = null;
        var syncTimer = null;

        var booleanNumberKeys = {
            aggressive: true,
            enabled: true,
            upgrade: true,
            staff: true,
            pvp: true,
            temporary: true,
            trade: true,
            market: true,
            member: true,
            members: true,
            membersonly: true,
            hidden: true,
            locked: true,
            active: true,
            boss: true,
            hardcore: true,
            repeatable: true
        };

        function updateCount() {
            if (!currentRoot) {
                count.textContent = '';
                return;
            }
            if (currentRoot.dataset.jsonKind === 'array') {
                var list = currentRoot.querySelector(':scope > .exp-array-list');
                var amount = list ? list.children.length : 0;
                count.textContent = amount + (amount === 1 ? ' entry' : ' entries');
                addEntryButton.hidden = false;
            } else {
                count.textContent = '1 content object';
                addEntryButton.hidden = true;
            }
        }

        function makeScalar(value, key) {
            var node = make('div', 'exp-json-node exp-scalar');
            node.dataset.jsonKind = 'scalar';
            var valueType = value === null ? 'null' : typeof value;
            node.dataset.valueType = valueType;

            var control;
            var lowerKey = String(key || '').toLowerCase().replace(/[^a-z0-9]/g, '');
            var numericBoolean = typeof value === 'number' && (value === 0 || value === 1) && booleanNumberKeys[lowerKey];

            if (typeof value === 'boolean' || numericBoolean) {
                control = make('select');
                var no = make('option', '', 'No / Disabled');
                var yes = make('option', '', 'Yes / Enabled');
                no.value = numericBoolean ? '0' : 'false';
                yes.value = numericBoolean ? '1' : 'true';
                control.appendChild(no);
                control.appendChild(yes);
                control.value = numericBoolean ? String(value) : String(Boolean(value));
                if (numericBoolean) node.dataset.valueType = 'number';
            } else if (typeof value === 'number') {
                control = make('input');
                control.type = 'number';
                control.step = Number.isInteger(value) ? '1' : 'any';
                control.value = String(value);
            } else if (value === null) {
                control = make('input');
                control.type = 'text';
                control.value = '';
                control.placeholder = 'null';
                var nullNote = make('small', 'exp-null-note', 'Leave blank to keep this value as null.');
                node.appendChild(nullNote);
            } else {
                var stringValue = String(value);
                if (stringValue.length > 100 || stringValue.indexOf('\n') !== -1) {
                    control = make('textarea');
                    control.value = stringValue;
                } else {
                    control = make('input');
                    control.type = 'text';
                    control.value = stringValue;
                }
            }

            control.setAttribute('data-exp-input', '1');
            node.insertBefore(control, node.firstChild);
            return node;
        }

        function makeObject(value, depth) {
            var node = make('div', 'exp-json-node exp-object');
            node.dataset.jsonKind = 'object';
            var grid = make('div', 'exp-object-grid');

            Object.keys(value).forEach(function (key) {
                var propertyValue = value[key];
                var nested = Array.isArray(propertyValue) || isPlainObject(propertyValue);
                var row = make('div', 'exp-object-property' + (nested ? ' exp-property-group' : ''));
                row.dataset.key = key;

                var label = make('div', 'exp-property-label');
                label.appendChild(make('span', '', humanize(key)));
                label.appendChild(make('code', '', key));
                row.appendChild(label);

                var holder = make('div', 'exp-property-value');
                holder.appendChild(makeNode(propertyValue, key, depth + 1));
                row.appendChild(holder);
                grid.appendChild(row);
            });

            if (Object.keys(value).length === 0) {
                grid.appendChild(make('div', 'expedition-editor-count', 'This object has no fields.'));
            }

            node.appendChild(grid);
            return node;
        }

        function refreshArrayLabels(node) {
            var list = node.querySelector(':scope > .exp-array-list');
            if (!list) return;
            var rootArray = node.dataset.depth === '0';
            Array.prototype.forEach.call(list.children, function (item, index) {
                var label = item.querySelector(':scope > .exp-array-item-header .exp-array-item-title strong');
                var small = item.querySelector(':scope > .exp-array-item-header .exp-array-item-title small');
                if (label) label.textContent = (rootArray ? 'Entry ' : 'Item ') + (index + 1);
                if (small) small.textContent = rootArray ? 'expedition content' : 'array value';
            });
            if (rootArray) updateCount();
        }

        function appendArrayItem(node, value) {
            var list = node.querySelector(':scope > .exp-array-list');
            if (!list) return;
            var depth = parseInt(node.dataset.depth || '0', 10);
            var item = make('div', 'exp-array-item' + (depth === 0 ? ' exp-root-entry' : ''));
            var header = make('div', 'exp-array-item-header');
            var title = make('div', 'exp-array-item-title');
            title.appendChild(make('strong', '', depth === 0 ? 'Entry' : 'Item'));
            title.appendChild(make('small', '', depth === 0 ? 'expedition content' : 'array value'));

            var actions = make('div', 'exp-array-actions');
            var toggle = button('Collapse', 'exp-btn-small');
            var duplicate = button('Duplicate', 'exp-btn-small');
            var remove = button('Remove', 'exp-btn-small exp-btn-danger');
            actions.appendChild(toggle);
            actions.appendChild(duplicate);
            actions.appendChild(remove);
            header.appendChild(title);
            header.appendChild(actions);

            var body = make('div', 'exp-array-item-body');
            body.appendChild(makeNode(value, node.dataset.contextKey || 'Item', depth + 1));
            item.appendChild(header);
            item.appendChild(body);
            list.appendChild(item);

            toggle.addEventListener('click', function () {
                item.classList.toggle('is-collapsed');
                toggle.textContent = item.classList.contains('is-collapsed') ? 'Expand' : 'Collapse';
            });

            duplicate.addEventListener('click', function () {
                var child = firstJsonNode(body);
                if (!child) return;
                appendArrayItem(node, cloneValue(serializeNode(child)));
                refreshArrayLabels(node);
                syncOutput();
            });

            remove.addEventListener('click', function () {
                item.remove();
                refreshArrayLabels(node);
                syncOutput();
            });

            refreshArrayLabels(node);
        }

        function makeArray(value, key, depth) {
            var node = make('div', 'exp-json-node exp-array');
            node.dataset.jsonKind = 'array';
            node.dataset.depth = String(depth);
            node.dataset.contextKey = key || 'Item';
            node._expTemplate = value.length ? blankLike(value[0]) : {};

            var list = make('div', 'exp-array-list');
            node.appendChild(list);

            value.forEach(function (item) {
                appendArrayItem(node, item);
            });

            var addWrap = make('div', 'exp-array-add');
            var add = button(depth === 0 ? '+ Add Expedition Entry' : '+ Add Item', depth === 0 ? 'exp-btn-primary' : '');
            addWrap.appendChild(add);
            node.appendChild(addWrap);

            node._expAddItem = function () {
                appendArrayItem(node, cloneValue(node._expTemplate));
                refreshArrayLabels(node);
                syncOutput();
            };
            add.addEventListener('click', node._expAddItem);
            return node;
        }

        function makeNode(value, key, depth) {
            if (Array.isArray(value)) return makeArray(value, key, depth);
            if (isPlainObject(value)) return makeObject(value, depth);
            return makeScalar(value, key);
        }

        function serializeNode(node) {
            if (!node) return null;
            var kind = node.dataset.jsonKind;

            if (kind === 'scalar') {
                var control = node.querySelector('[data-exp-input]');
                var rawValue = control ? control.value : '';
                var type = node.dataset.valueType;
                if (type === 'number') {
                    if (rawValue === '') return 0;
                    var number = Number(rawValue);
                    return Number.isFinite(number) ? number : 0;
                }
                if (type === 'boolean') return rawValue === 'true';
                if (type === 'null') return rawValue.trim() === '' ? null : rawValue;
                return rawValue;
            }

            if (kind === 'object') {
                var result = {};
                var grid = node.querySelector(':scope > .exp-object-grid');
                if (!grid) return result;
                Array.prototype.forEach.call(grid.children, function (row) {
                    var key = row.dataset.key;
                    if (key === undefined) return;
                    var holder = row.querySelector(':scope > .exp-property-value');
                    var child = firstJsonNode(holder);
                    result[key] = serializeNode(child);
                });
                return result;
            }

            if (kind === 'array') {
                var values = [];
                var list = node.querySelector(':scope > .exp-array-list');
                if (!list) return values;
                Array.prototype.forEach.call(list.children, function (item) {
                    var body = item.querySelector(':scope > .exp-array-item-body');
                    var child = firstJsonNode(body);
                    values.push(serializeNode(child));
                });
                return values;
            }

            return null;
        }

        function setStatus(message, isError) {
            status.textContent = message || '';
            status.classList.toggle('is-error', Boolean(isError));
            status.classList.toggle('is-ok', Boolean(message) && !isError);
        }

        function syncOutput() {
            if (!currentRoot) return;
            var data = serializeNode(currentRoot);
            var compact = JSON.stringify(data);
            output.value = compact;
            raw.value = JSON.stringify(data, null, 2);
            setStatus('Structured fields and JSON are in sync.', false);
            updateCount();
        }

        function queueSync() {
            window.clearTimeout(syncTimer);
            syncTimer = window.setTimeout(syncOutput, 120);
        }

        function mount(data) {
            structured.innerHTML = '';
            currentRoot = makeNode(data, 'Content', 0);
            currentRoot.classList.add('exp-root-node');
            structured.appendChild(currentRoot);
            raw.value = JSON.stringify(data, null, 2);
            output.value = JSON.stringify(data);
            setStatus('Structured editor loaded.', false);
            updateCount();
        }

        structured.addEventListener('input', function (event) {
            if (event.target.matches('[data-exp-input]')) queueSync();
        });
        structured.addEventListener('change', function (event) {
            if (event.target.matches('[data-exp-input]')) syncOutput();
        });

        addEntryButton.addEventListener('click', function () {
            if (currentRoot && currentRoot.dataset.jsonKind === 'array' && typeof currentRoot._expAddItem === 'function') {
                currentRoot._expAddItem();
            }
        });

        expandButton.addEventListener('click', function () {
            structured.querySelectorAll('.exp-array-item.is-collapsed').forEach(function (item) {
                item.classList.remove('is-collapsed');
                var toggle = item.querySelector(':scope > .exp-array-item-header .exp-array-actions .exp-btn');
                if (toggle) toggle.textContent = 'Collapse';
            });
        });

        collapseButton.addEventListener('click', function () {
            structured.querySelectorAll('.exp-array-item').forEach(function (item) {
                item.classList.add('is-collapsed');
                var toggle = item.querySelector(':scope > .exp-array-item-header .exp-array-actions .exp-btn');
                if (toggle) toggle.textContent = 'Expand';
            });
        });

        applyRawButton.addEventListener('click', function () {
            try {
                var data = JSON.parse(raw.value || '[]');
                mount(data);
                setStatus('Raw JSON applied to the structured fields.', false);
            } catch (error) {
                setStatus('Invalid JSON: ' + error.message, true);
            }
        });

        formatRawButton.addEventListener('click', function () {
            try {
                var data = JSON.parse(raw.value || '[]');
                raw.value = JSON.stringify(data, null, 2);
                setStatus('JSON formatted. Click Apply Raw JSON to load it into the fields.', false);
            } catch (error) {
                setStatus('Invalid JSON: ' + error.message, true);
            }
        });

        form.addEventListener('submit', function () {
            window.clearTimeout(syncTimer);
            syncOutput();
        });

        mount(parsed);
    });
})();
