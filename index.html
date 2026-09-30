<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Kaitun Remote Control Panel</title>
    <style>
        body { background: #0f172a; color: #f8fafc; font-family: Arial, sans-serif; padding: 20px; }
        .card { background: #1e293b; padding: 20px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.3); }
        h2 { color: #38bdf8; margin-top: 0; }
        .toggle-row { display: flex; justify-content: space-between; align-items: center; margin: 10px 0; background: #0f172a; padding: 10px; border-radius: 8px; }
        ul { padding-left: 20px; max-height: 150px; overflow-y: auto; }
    </style>
</head>
<body>
    <h1>Kaitun Mobile Dashboard</h1>

    <!-- LIVE STATS SECTION -->
    <div class="card">
        <h2 id="username">Connecting...</h2>
        <p><strong>Level:</strong> <span id="level">--</span></p>
        <p><strong>Race:</strong> <span id="race">--</span></p>
    </div>

    <!-- CONTROL PANEL SECTION (Toggles) -->
    <div class="card">
        <h2>Remote Controls</h2>
        <div class="toggle-row">
            <span>Auto Farm Level</span>
            <input type="checkbox" id="AutoFarmLevel" onclick="toggleSetting('AutoFarmLevel')">
        </div>
        <div class="toggle-row">
            <span>Auto Store Fruit</span>
            <input type="checkbox" id="AutoStoreFruit" onclick="toggleSetting('AutoStoreFruit')">
        </div>
        <div class="toggle-row">
            <span>Auto Haki</span>
            <input type="checkbox" id="AutoHaki" onclick="toggleSetting('AutoHaki')">
        </div>
    </div>

    <!-- INVENTORY SECTION -->
    <div class="card">
        <h2>Inventory (Fruits & Swords)</h2>
        <ul id="inventory-list"><li>Loading inventory...</li></ul>
    </div>

    <script>
        const API_URL = "https://your-database-endpoint.com/settings";

        async function syncDashboard() {
            try {
                let res = await fetch(API_URL + "/get");
                let data = await res.json();

                // Update text stats
                document.getElementById('username').innerText = data.Username || "Unknown Account";
                document.getElementById('level').innerText = data.Level || 0;
                document.getElementById('race').innerText = data.Race || "Unknown";

                // Update checkboxes based on cloud state
                if(data.CurrentSettings) {
                    document.getElementById('AutoFarmLevel').checked = data.CurrentSettings.AutoFarmLevel;
                    document.getElementById('AutoStoreFruit').checked = data.CurrentSettings.AutoStoreFruit;
                    document.getElementById('AutoHaki').checked = data.CurrentSettings.AutoHaki;
                }

                // Update inventory list
                let invList = document.getElementById('inventory-list');
                invList.innerHTML = '';
                if (data.Inventory && data.Inventory.length > 0) {
                    data.Inventory.forEach(item => {
                        let li = document.createElement('li');
                        li.innerText = `${item.Name} (${item.Type}) - Count: ${item.Count}`;
                        invList.appendChild(li);
                    });
                } else {
                    invList.innerHTML = '<li>Inventory is empty.</li>';
                }
            } catch (e) {
                console.error("Dashboard sync error:", e);
            }
        }

        async function toggleSetting(settingName) {
            let isChecked = document.getElementById(settingName).checked;
            await fetch(API_URL + "/set", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ setting: settingName, value: isChecked })
            });
        }

        setInterval(syncDashboard, 5000); // Refresh every 5 seconds
        syncDashboard();
    </script>
</body>
</html>
