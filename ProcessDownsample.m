function [P,F,T,data] = ProcessDownsample(file, overlap, timeres, leakage)            
            Fs=3906;
            % Converter para complexo
            data = double(complex( file.Data(1:2:end) - mean(file.Data(1:2:end)), ...
                file.Data(2:2:end) - mean(file.Data(2:2:end)) ));
            Fc = str2double( extractBetween(file.Filename,'_f_','.bin'));
            data = resample(data,44.1e3,Fs);

            try
                [P, F, T] = pspectrum(data, 44.1e3, 'spectrogram', ...
                'OverlapPercent', overlap, ...
                'TimeResolution', timeres, ...
                'Leakage', leakage);
            catch
                P = 0;
                F = 0;
                T = 0;
                return;
            end

            F = (F/1e6)+Fc;
            P = rot90( pow2db(P) );
end